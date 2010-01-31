Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584Ab0AaPmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab0AaPmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 10:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425Ab0AaPmE
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 10:42:04 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:59226 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0AaPmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 10:42:00 -0500
Date: Sun, 31 Jan 2010 17:41:52 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A spammer, wanting to poison our bayes seems to have found a
 hole at vger.kernel.org
Message-ID: <20100131154152.GT3486@mea-ext.zmailer.org>
References: <201001302313.19206.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001302313.19206.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 11:13:19PM -0500, Gene Heskett wrote:
> Greeting;
> 
> I just noticed that I have a poison bayes spam in my inbox cuz kmails filters 
> haven't a clue what to do with a message addressed like this:
> 
> to:linux-kernel-outgoing@vger.kernel.org
> 
> Is this a leak in the mailing list server, or a total forgery?

It was real, and bypassed Majordomo processing entirely.
Now I have added some extra "secret sauce" on all outgoing aliases.

> -- 
> Cheers, Gene

/Matti
