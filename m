Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbYBHFVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbYBHFVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYBHFVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:21:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:62321 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYBHFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ysc7SjyfG/vqeubzbvygTZv6ab/lev6DyHOfbYhQuZLInXF9o4/x0V5anpRF8yd1iPuQqapFJN88OatMtNjCSmgv5K3wRfdUd0rBVyL+SWZ2me8Mbszk0koR0mOpSZx0a4wbvdPtD7kf+rWecIA39wjH28u1PBhQ8RY5jH5WymA=
Message-ID: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
Date: Fri, 8 Feb 2008 10:51:33 +0530
From: "rohit h" <hrohit85@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [LINUX-KERNEL] C++ in linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I am a kernel newbie.
 I tried to insmod a C++ module containing classes, inheritance.
 I am getting 'unresolved symbol' error when I use the 'new' keyword.
 What could the problem be?

 What kind of runtime support is needed ( arm linux kernel)? Is a
patch available for it?

 Thanks,
Rohit
