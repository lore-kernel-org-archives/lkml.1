Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYDTCaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYDTCaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYDTC35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:29:57 -0400
Received: from quechua.inka.de ([193.197.184.2]:55467 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbYDTC35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:29:57 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap) partitions on a SATA drive
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <480A9C1E.8050505@blueyonder.co.uk>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JnPJR-0008NL-00@calista.eckenfels.net>
Date: Sun, 20 Apr 2008 04:29:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <480A9C1E.8050505@blueyonder.co.uk> you wrote:
> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3. 
> With xfs it can't find these and drops into a shell.

Do you have reiser and ext3 as modules as well? If yes, how do you load them
(i.e. which distribution, bootload and initram you are using?)

Gruss
Bernd
