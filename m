Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZF1Soz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZF1Soz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF1Sor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:44:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:50678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZF1Sor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:44:47 -0400
Date: Sun, 28 Jun 2009 11:45:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/62] Remove unnecessary semicolons
Message-ID: <20090628114548.2751f7df@infradead.org>
In-Reply-To: <20090628.113234.28471959.davem@davemloft.net>
References: <20090628101159.4c35a4db@infradead.org>
	<1246209365.13673.5.camel@Joe-Laptop.home>
	<20090628104332.482ee449@infradead.org>
	<20090628.113234.28471959.davem@davemloft.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 11:32:34 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Arjan van de Ven <arjan@infradead.org>
> Date: Sun, 28 Jun 2009 10:43:32 -0700
> 
> > On Sun, 28 Jun 2009 10:16:05 -0700
> > Joe Perches <joe@perches.com> wrote:
> > 
> >> On Sun, 2009-06-28 at 10:11 -0700, Arjan van de Ven wrote:
> >> > can you improve your descriptions please?
> >> > to at least include the why for a change, not just the how and
> >> > what...
> >> 
> >> Is any part of "Remove unnecessary semicolons" unclear?
> >> 
> >> What would you prefer?
> >> 
> > 
> > your sentence addresses the what question, no the why question
> > 
> I think you're going overboard in these requirements.
> 
> Extraneous semi-colons dirty up the code, make it confusing and make
> hard to find bugs more likely to be present or (even worse) get added
> unintentionally in the future.

... and this sentence would have been a really good changelog.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
