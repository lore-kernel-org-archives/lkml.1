Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXJAHgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXJAHgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXJAHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:36:35 -0400
Received: from tidos.tid.es ([193.145.240.2]:58768 "EHLO correo.tid.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXJAHge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:36:34 -0400
Date: Mon, 01 Oct 2007 09:36:05 +0200
From: Miguel <mc354@tid.es>
Subject: Re: software unplug and plug USB
In-reply-to: <46FCF0F5.9030004@wpkg.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <1191224165.6014.12.camel@McM>
MIME-version: 1.0
X-Mailer: Evolution 2.10.1
Content-type: text/plain
Content-transfer-encoding: 7BIT
References: <46FCF0F5.9030004@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

actually, I have a USB keyboard, could that be the problem? why?

removing and adding modules doesn't solve my problem... The USB has
several functions: modem and usb mass storage and only the storage one
is recognized 
:(

any thoughts?

On Fri, 2007-09-28 at 14:17 +0200, Tomasz Chmielewski wrote:
> > I'm using a huawei E220 modem and occasionally it doesn't work and I
> > must unplug and plug it again, run the scripts connection to make it
> > works again.
> > how can I unplug an plug an USB modem via software?
> 
> If the modem doesn't have any other power sources than USB, just 
> removing the modem's and USB modules, and the modprobing them again 
> should help.
> 
> Just take care if you have it connected to the PC with a USB keyboard ;)
> 
> 

