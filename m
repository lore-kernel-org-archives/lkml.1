Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbZLKNix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbZLKNix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZLKNit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:38:49 -0500
Received: from snt0-omc1-s29.snt0.hotmail.com ([65.55.90.40]:27087 "EHLO
	snt0-omc1-s29.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZLKNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:38:48 -0500
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS372EC73016B4FB39E0ACAA78C0@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Finding and chaniging registered clocksources
Date: Fri, 11 Dec 2009 13:38:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp6Z0bbLOxQQ22ETvKw9IEUZpJf7w==
Content-Language: en-gb
X-OriginalArrivalTime: 11 Dec 2009 13:38:55.0526 (UTC) FILETIME=[48CF8460:01CA7A67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have some questions regarding clocksource and I will really appreciate it
if someone is willing to help me.

I know how to force the kernel to use a specific clocksource for driving the
scheduler and verify that this clocksource is used.

However, I don't know how to found out what clocksource Linux has assigned
for other activities apart from the one mentioned (e.g. for timekeeping) and
how to change it, if possible.

For example, I want to find out which clocksource getnstimeofday() is using.
It could be also useful if there is a way to see all the registered
clocksources in the system. 

Thanks in advance. 

P.S. please cc me.

