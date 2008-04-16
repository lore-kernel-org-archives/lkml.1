Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYDPTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYDPTn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYDPTnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:43:18 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:40635
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYDPTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:43:18 -0400
X-Trace: 61168875/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAODzBUhTQwss/2dsb2JhbACBYKx7
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Western Digital GreenPower drives and Linux
Date: Wed, 16 Apr 2008 20:44:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200804092118.35501.tvrtko@ursulin.net> <4805E59E.1020607@aitel.hist.no> <bb145bd20804161059u4fe45debs22adf337fef143aa@mail.gmail.com>
In-Reply-To: <bb145bd20804161059u4fe45debs22adf337fef143aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804162044.03569.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008 18:59:24 Christian Pernegger wrote:
> > > At this rate the disk would reach it's design limit for load/unload
> > > cycles
> >
> > in around 80 days.
>
> Design *minimum* for load/unload cycles is reportedly 600K cycles,
> that would give me over 7.5 years of 24/7 operation, which I can live
> with in cheap high capacity drives that have only 5 years of warranty
> anyway.

That is what they said to me as well. But their datasheet says it is 300k for 
desktop and 600k cycles for RAID edition drives. It also doesn't mention 
minimum but "Controlled unloads at ambient condition". But that's probably 
fine.. you are just in luck that you don't use them as system drives. As I 
said before, with timer set to 25.5s they are fine for me now - I am seeing 
just two unload cycles per hour on average, that is by factor of 100 less 
than before.

Tvrtko
