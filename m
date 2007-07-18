Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXGRJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXGRJSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXGRJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:17:52 -0400
Received: from mx.fr.bfs.de ([194.95.226.137]:53207 "EHLO mail.fr.bfs.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbXGRJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:17:51 -0400
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 05:17:51 EDT
Message-ID: <469DD37C.8050200@bfs.de>
Date: Wed, 18 Jul 2007 10:46:52 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: crash with 2.6.21 BUG:ll_rw_blk.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi list,
i managed to crash 2.6.21 at boottime with

IPI Shortcut mode
BUG: atblock/ll_rw_blc.c 1566 blk_remove_plug()


system: acer Notebook TM620

does anyone care or is 2.6.21 already done ?

re,
 wh
