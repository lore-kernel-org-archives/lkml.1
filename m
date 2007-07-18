Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXGRFdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXGRFdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXGRFcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:32:54 -0400
Received: from nn7.de ([85.214.94.156]:53234 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbXGRFcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:32:54 -0400
Subject: Re: [PATCH] appletouch powersaving - please apply for
	2.6.23-rc1	take #3
From: Soeren Sonnenburg <kernel@nn7.de>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nicolas Boichat <nicolas@boichat.ch>,
       Michael Hanselmann <linux-kernel@hansmi.ch>,
       Peter Osterlund <petero2@telia.com>,
       Frank Arnold <frank@scirocco-5v-turbo.de>,
       Stelian Pop <stelian@popies.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <greg@kroah.com>
In-Reply-To: <200707172148.58367.dtor@insightbb.com>
References: <1184656218.14051.43.camel@localhost>
	 <d120d5000707170801u27e11936h9546bd36da7a1162@mail.gmail.com>
	 <1184696179.6161.18.camel@localhost>
	 <200707172148.58367.dtor@insightbb.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Jul 2007 05:32:49 +0000
Message-Id: <1184736769.6161.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 21:48 -0400, Dmitry Torokhov wrote:
> On Tuesday 17 July 2007 14:16, Soeren Sonnenburg wrote:
> > On Tue, 2007-07-17 at 11:01 -0400, Dmitry Torokhov wrote:
> [...]
> > > How many boxes did you try this patch on?
> > 
> > Mine plus 1 other. However please note that Matthews patch has been
> > (which is what this patch is based on) is in the mactel-patches
> > repository for quite some time now and that the not-yet-cleanup up
> > variant of this patch was posted to mactel-devel...
> > 
> > So the modeswitch part should work...
> > 
> 
> OK, can I please get signed-off-bys for the latest version so I can
> apply it?

They are the same as in the initial patch:

Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
