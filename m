Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0BZKoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:44:24 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:36774 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab0BZKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uNZcrfzV9kfXMLjUulwKSCdPEk989f//9csxDZ6A98WBzaNZpr8cutZkoX2nl4EEtH
         w8jgL78lNuhhgTZPuVe9uYeddNxiadTQQ5K6PqUTB+vUAWnQhTVvqAIPwwqubmtj6eFm
         CPJUdn+UgOGOpQZOHUIjjJuk7aUf/JQZDnqto=
MIME-Version: 1.0
Date: Fri, 26 Feb 2010 16:14:22 +0530
Message-ID: <9bde694e1002260244u25cfa332l82c488702e4b9900@mail.gmail.com>
Subject: memory leak in case of Kernel module
From: naveen yadav <yad.naveen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I need small clarification, If I have a kernel module and in init I
create some memory using vmalloc. and i do not free it. I exit from
the module.

what happen to this allocated memory. Will kernel handle it and do free.


Regards
Naveen
