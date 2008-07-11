Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbYGKOwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbYGKOwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYGKOwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:52:23 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:32878 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYGKOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:52:22 -0400
From: "K. Ernel" <kernel@wildsau.enemy.org>
Message-Id: <200807111451.m6BEppiI015462@wildsau.enemy.org>
Subject: Re: CONFIG_NETWORK_FILESYSTEMS not set in /proc/config.gz
In-Reply-To: <20080709214429.63f792d2.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 11 Jul 2008 16:51:51 +0200 (MET DST)
CC: linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't reproduce it on 2.6.25.9 or 2.6.26-rc9.

Hello Randy,

you are right, I can't reproduce it either. I tried several
kernel versions and even downgraded to 2.6.24, checking
whether the configuration settings was lost when switching
from 24 to 25. But this is not the case.

Seems I've lost that particular settings some other way.

I'm terribly sorry for wasting your time. I owe you a beer!

kind regards,
H.Rosmanith

