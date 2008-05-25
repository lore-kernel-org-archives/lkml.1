Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYEYKza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYEYKza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYEYKzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:55:18 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37051 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbYEYKzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:55:17 -0400
Date: Sun, 25 May 2008 12:54:22 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sdricohcs-devel@lists.sourceforge.net
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Message-ID: <20080525125422.0ec82f74@mjolnir.drzeus.cx>
In-Reply-To: <20080525124601.4d8d48cc@mjolnir.drzeus.cx>
References: <200804271617.53438.saschasommer@freenet.de>
	<200805111050.55662.saschasommer@freenet.de>
	<20080512195435.4d2d3b58@mjolnir.drzeus.cx>
	<200805181405.05774.saschasommer@freenet.de>
	<20080525124601.4d8d48cc@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be clear, the only thing holding this patch back is the
reliance on opcodes. Once that can be fixed then I'll merge the driver.

(And by fix I don't mean "make those opcodes work", I mean "figure out
the command properties instead of lists of opcodes")

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
