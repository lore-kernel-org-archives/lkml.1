Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZAELS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZAELS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZAELSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:18:16 -0500
Received: from mail.crca.org.au ([67.207.131.56]:55155 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZAELSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:18:15 -0500
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       fweisbec@gmail.com, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20090105025300.3afbec23@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	 <1231135294.8179.45.camel@nigel-laptop>
	 <20090105025300.3afbec23@infradead.org>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 22:18:25 +1100
Message-Id: <1231154305.8179.148.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2009-01-05 at 02:53 -0800, Arjan van de Ven wrote:
> On Mon, 05 Jan 2009 17:01:34 +1100
> Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:
> 
> > Hi Arjan.
> > 
> > Great work, and valuable too. I'm just wondering if the header file
> > name "async.h" is a little too generic? Something like async_init.h
> > perhaps?
> > 
> 
> while the users I have in mind are during init, the concept and
> infrastructure of asynchronous function calls is by no means limited to
> that use case... I hope there are many other uses for this :)

Okee doke. How about async_fn or something like that then? It's just
that there's async I/O and no doubt other async stuff I haven't thought
of. Still, it's a relatively minor point.

Night!

Nigel

