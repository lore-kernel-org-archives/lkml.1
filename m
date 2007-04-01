Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbXDARiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbXDARiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXDARiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:38:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:52396 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933691AbXDARiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:38:18 -0400
Date: Sun, 1 Apr 2007 19:43:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, Dan Engel <dan@sourceharvest.com>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
In-Reply-To: <200704011057.40725.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
References: <1175396188.7857.15.camel@monica.engel.home>
 <Pine.LNX.4.64.0704011057420.6040@jikos.suse.cz> <200704011057.40725.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Dmitry Torokhov wrote:

> No, I do not want to add any more LED constants to input. In fact I 
> think that adding constants beyond keyboard indicators was a mistake. We 
> have led subsystem that provides interface to control arbitrary leds and 
> we should use it.

Ah, of course. Dan, could you please redo the patch to use the leds 
infrastructure and send it to me?

Thanks,

-- 
Jiri Kosina
