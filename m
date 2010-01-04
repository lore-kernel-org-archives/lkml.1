Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ADIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ADIHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 03:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917Ab0ADIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 03:07:10 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61089 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0ADIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 03:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jKMQ0x7qPQPVzwqbhpuvlrt2ZJExrrDnzWAwCu2vCHx97HMqSca7qieKTDUMKKcvIh
         mr/unpqDVPqz7pd1EDbeOzZnu2sCaWQub/uJsFOP9nUh+WgyJGus3Qm3XjC02zqTVtik
         N1fvciYRuydkmxg3+htAJJJAk5UkKLx0ajaEE=
MIME-Version: 1.0
Date: Mon, 4 Jan 2010 00:07:06 -0800
Message-ID: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com>
Subject: init_task belongs to "process 0" or "process 1"?
From: Shivdas Gujare <shivdas.tech@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shivdas Gujare <shivdas.tech@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to understand the role of linux kernel "process 0" i.e. swapper.
I am not able to understand, where it gets started? and Does
"init_task" from arch/arm/kernel/init_task.c belongs to "swapper" or
"init"?
whats the purpose of "init_task"?

Thanks for your help.

Thanks and Regards,
Shivdas Gujare
