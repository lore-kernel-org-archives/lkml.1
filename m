Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXBKVpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXBKVpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbXBKVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:45:13 -0500
Received: from main.gmane.org ([80.91.229.2]:36003 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932560AbXBKVpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:45:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Neil Schemenauer <nas@arctrix.com>
Subject: Re: sata_nv - ADMA issues with 2.6.20
Date: Sun, 11 Feb 2007 19:55:37 +0000 (UTC)
Message-ID: <eqnsbp$5fn$1@sea.gmane.org>
References: <fa.uoZWqSFxPjjB7zobQOwk/2zqG5A@ifi.uio.no> <45CD20DB.9030808@shaw.ca>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000625c557dc.ss.shawcable.net
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> David R wrote:
>>>> Feb  9 18:40:29 server kernel: ata7: Resetting port
>>>> Feb  9 18:40:29 server kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
>>>> Feb  9 18:40:29 server kernel: ata7.00: cmd 61/08:00:1f:e4:50/00:00:09:00:00/40 tag 0 cdb 0x0 data 4096 out
>>>> Feb  9 18:40:29 server kernel:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

I'm setting similar errors on my machine (AMD64 CPU, MSI board with
NForce chipset).  Linux 2.6.19.2 seems to be okay.

  Neil

