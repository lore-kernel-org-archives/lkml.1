Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXJAWiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXJAWiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXJAWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:38:43 -0400
Received: from ara.aytolacoruna.es ([212.51.63.12]:36468 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXJAWim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:38:42 -0400
Date: Tue, 2 Oct 2007 00:38:35 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (repost) Fix SMP poweroff hangs
Message-ID: <20071001223835.GB2455@pul.manty.net>
References: <46FC20B7.4000606@rtr.ca> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <200710012205.14303.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710012205.14303.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There was a bug in 2.6.23-rc8 that caused this to happen.
> 
> It's been fixed in the later -git kernels
> (commits 2f3f22269bdf702311342c5d106dfdd7347d1c3e,
> 853298bc03ef65e3eb392f5d61265605214ee8fb).

You are right, I have downloaded current head of git and seems to work ok.

Sorry for the lost time :-(

Regards...
-- 
Manty/BestiaTester -> http://manty.net
