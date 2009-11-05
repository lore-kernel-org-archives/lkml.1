Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZKEAcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZKEAcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZKEAcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:32:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57190 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZKEAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:32:12 -0500
Date: Wed, 4 Nov 2009 22:31:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-media@vger.kernel.org,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 0/3 v2] linux infrared remote control drivers
Message-ID: <20091104223136.62cfc791@pedra.chehab.org>
In-Reply-To: <C5A8E7EC-81D6-49AA-A65F-9F5D3DED1690@wilsonet.com>
References: <200910200956.33391.jarod@redhat.com>
	<C5A8E7EC-81D6-49AA-A65F-9F5D3DED1690@wilsonet.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 4 Nov 2009 17:56:31 -0500
Jarod Wilson <jarod@wilsonet.com> escreveu:

> On Oct 20, 2009, at 9:56 AM, Jarod Wilson wrote:
> 
> > This here is a second go at submitting linux infrared remote control
> > (lirc) drivers for kernel inclusion, with a much smaller patch set  
> > that
> > includes only the core lirc driver and two device drivers, all three  
> > of
> > which have been heavily updated since the last submission, based on
> > feedback received.
> 
> Hm. Submitting this while the vast majority of people who might review  
> it were at the Japan Linux Symposium seems like it might have been a  
> bad idea. 

True :) Such long trips generally affects the week before (to finish some
pending stuff before traveling) and the week after, where we have a big
backlog to handle.

> Or does no feedback mean its all good and ready to be  
> merged? ;)

They are on my queue. I was handling a long pile of patches for the existing
drivers during last week. I intend to send the fixes upstream during this week,
and then going to analyze the lirc patches.

It would be wonderful to get also some feedback from the event/input people.

Cheers,
Mauro
