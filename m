Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXA2PMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXA2PMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXA2PMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:12:36 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:50535 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXA2PMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:12:35 -0500
Subject: Re: 2.6.20-rc6 pb_fnmode regression
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0701291237570.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>
	 <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
	 <1170066737.13904.12.camel@localhost>
	 <Pine.LNX.4.64.0701291138260.9448@twin.jikos.cz>
	 <Pine.LNX.4.64.0701291202230.9448@twin.jikos.cz>
	 <1170069874.13904.29.camel@localhost>
	 <Pine.LNX.4.64.0701291237570.9448@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jan 2007 16:12:25 +0100
Message-Id: <1170083545.3411.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 12:45 +0100, Jiri Kosina wrote:
> On Mon, 29 Jan 2007, Soeren Sonnenburg wrote:
> 
> > That sounds good for me. Breaking with what was there is not a problem 
> > as long as this feature is still there, it can be done in a more clean 
> > way this way, and the new /sys/foo/bar path is documented (basically 
> > people nowadays expect slight user interface changes between kernel 
> > versions).
> 
> So, does the patch below look OK to powerbook people? The only difference 
> is that the module taking care of pb_fnmode parameter is now hid, instead 

For me yes ... I just rebooted and checked fn_modes ... it works nicely.
So I guess this should be applied ?!

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
