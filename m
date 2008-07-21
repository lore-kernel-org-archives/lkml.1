Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYGUVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYGUVXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYGUVXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:23:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:46306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYGUVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:23:32 -0400
Date: Mon, 21 Jul 2008 14:23:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ben Collins <bcollins@swissdisk.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080721142315.4076c292@infradead.org>
In-Reply-To: <1216673584.7585.189.camel@cunning>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
	<20080721134327.3ffab96f@infradead.org>
	<1216673584.7585.189.camel@cunning>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 16:53:04 -0400
Ben Collins <bcollins@swissdisk.com> wrote:

> On Mon, 2008-07-21 at 13:43 -0700, Arjan van de Ven wrote:
> > On Mon, 21 Jul 2008 15:39:44 -0400
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > Not all X drivers save and restore fonts on text VTs. Add code to
> > > the kernel to explicitly save and restore them on VT switches.
> > 
> > 
> > do you have a list of which ones don't ?
> 
> I don't, but perhaps Matthew does.
> 
I was assuming Matthew would respond since he sent this patch to lkml
after all...
