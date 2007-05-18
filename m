Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXERQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXERQem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbXERQeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:34:36 -0400
Received: from quechua.inka.de ([193.197.184.2]:52199 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbXERQeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:34:36 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] log out-of-virtual-memory events
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <464DCEAB.3090905@users.sourceforge.net>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>
Date: Fri, 18 May 2007 18:34:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <464DCEAB.3090905@users.sourceforge.net> you wrote:
>        printk("%s/%d: potentially unexpected fatal signal %d.\n",
>                current->comm, current->pid, signr);

can we have both KERN_WARNING please?

Gruss
Bernd
