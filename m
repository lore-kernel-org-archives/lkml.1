Return-Path: <linux-kernel-owner+w=401wt.eu-S934367AbXEGPfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbXEGPfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934346AbXEGPfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:35:13 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:58654 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934311AbXEGPfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:35:12 -0400
Date: Mon, 7 May 2007 18:35:11 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070507153511.GH3883@mea-ext.zmailer.org>
References: <20070507145555.GG3883@mea-ext.zmailer.org> <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:03:54AM -0400, John Anthony Kazos Jr. wrote:
> > In the  linux-kernel  -list subscribers domain popularity
> > analysis I got following results:
> > 
> >    2101 gmail.com
> >      49 googlemail.com
> >      46 gmx.de
.... 
> How about some elitism here? Dedicate a certain number of streams to 
> everything-except-gmail, so MTAs from the 21st century can get their mail 
> faster, and set the rest on gmail-only. Slows down gmail and speeds up the 
> rest?

No need.  gmail has done that slowing down all by themselves quite handily..

VGER has dedicated number of streams to gmail, and bigger pools to elsewere.
The gmail parallelism-pool is configured so that daily message volume does
usually make it thru in a day.  I would prefer it going much faster...

If you are interested to see VGER's queues and monitor gauges, they are viewable
with tools at web-page:

   http://vger.kernel.org/z/

Most of what it tells is not easily understandable, and much needs deep internal
system knowledge to be understood at all - but mostly the queue display is
self-explanatory.

  /Matti Aarnio

PS: Contact address for VGER's postmasters is:  postmaster@vger.kernel.org
