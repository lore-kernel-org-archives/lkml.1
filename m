Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbXFGPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbXFGPxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765810AbXFGPwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:52:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765630AbXFGPwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:52:23 -0400
Date: Thu, 7 Jun 2007 08:52:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Peter Jones <pjones@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070607085200.f8d6e2d3.akpm@linux-foundation.org>
In-Reply-To: <20070607154342.GA16911@suse.de>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4667018D.7020407@googlemail.com>
	<1181168095.3612.4.camel@lov.localdomain>
	<4667C47C.2010207@googlemail.com>
	<1181206091.3625.9.camel@lov.localdomain>
	<4667D2DF.30207@googlemail.com>
	<1181228660.3625.23.camel@lov.localdomain>
	<46682385.1060802@redhat.com>
	<20070607154342.GA16911@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 08:43:42 -0700 Greg KH <gregkh@suse.de> wrote:

> >  Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
> >  updates-testing.  Thanks for getting my attention here.
> 
> Great, Andrew, can you please reenable the block-device patch that is in
> my tree now that the problem has been solved?

I think we're screwed, aren't we?  Everyone needs to upgrade mkinitrd to be
able to boot the kernel?  Not viable :(

For example, what about my two-year-old yellowdog machine?
