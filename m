Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbXLBUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbXLBUG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXLBUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:06:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXLBUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:06:16 -0500
Date: Sun, 2 Dec 2007 21:06:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, tvrtko.ursulin@sophos.com,
       Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071202200611.GA17966@one.firstfloor.org>
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com> <20071201084332.GB4446@ucw.cz> <17957.1196624688@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17957.1196624688@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and I don't think you can mmap() a socket anyhow,
> right?

You can mmap packet sockets.

-Andi

