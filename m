Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXITPQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXITPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXITPQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:16:21 -0400
Received: from vena.lwn.net ([206.168.112.25]:54355 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbXITPQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:16:21 -0400
To: Andres Salomon <dilinger@queued.net>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm@linux-foundation.org, mchehab@infradead.org,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] cafe_ccic: default to allocating DMA buffers at probe time 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 19 Sep 2007 18:43:38 EDT."
             <20070919184338.64fc6e89.dilinger@queued.net> 
Date: Thu, 20 Sep 2007 09:16:20 -0600
Message-ID: <1068.1190301380@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon <dilinger@queued.net> wrote:

> That said, I'm not opposed to keeping the parameter name the same while
> making the default 1; I just thought that the name 'alloc_bufs_at_read' was
> clearer.  Another option is to change it to 'no_alloc_bufs_at_load'.  Jon,
> any preference there?

I don't think that negating it by adding no_ at the front helps much.
In general, I prefer the name it has now, but it's not *that* big a
deal.  We've probably already expended more bandwidth than it's worth.

jon
