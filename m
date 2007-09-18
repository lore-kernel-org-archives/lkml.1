Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbXIRRiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbXIRRiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbXIRRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:38:43 -0400
Received: from relais.videotron.ca ([24.201.245.36]:57986 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759911AbXIRRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:38:43 -0400
Date: Tue, 18 Sep 2007 13:38:39 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] ucb1400_ts.c -- replace an interruptible sleep with an
 uninterruptible one
In-reply-to: <46F00AA8.4090806@gmail.com>
X-X-Sender: nico@xanadu.home
To: Rene Herman <rene.herman@gmail.com>
Cc: Dmitry Torokhov <dtor_core@ameritech.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.0.9999.0709181338040.26525@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <46EFE66A.9090400@gmail.com>
 <alpine.LFD.0.9999.0709181203190.26525@xanadu.home>
 <46F00AA8.4090806@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Rene Herman wrote:

> On 09/18/2007 06:03 PM, Nicolas Pitre wrote:
> 
> > On Tue, 18 Sep 2007, Rene Herman wrote:
> > 
> > > Hi Nicolas.
> > > 
> > > Given that it's not checking for signals, I believe this one should be an
> > > uninterruptible sleep instead?
> > 
> > Probably.
> 
> Thanks. Should I send it somewhere or will you or Dmitry grab it?

Please send it to Dmitry  with my ACK.


Nicolas
