Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXE1Van@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXE1Van (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbXE1Vag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:30:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41073 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXE1Vaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:30:35 -0400
Date: Mon, 28 May 2007 23:30:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705282326480.11140@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28 2007 16:15, Robert P. J. Day wrote:
>removing dead content from the tree:
>
>http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
>
>currently, the list contains the items:
>
>    * 4 Traffic policing

CONFIG_NET_SCHED? CONFIG_NET_ACT_POLICE? Neither seems
marked as deprecated/obsoleted in Kconfig.



	Jan
-- 
