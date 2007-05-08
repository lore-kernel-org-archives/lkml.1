Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXEHGnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXEHGnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXEHGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:43:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41587 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbXEHGnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:43:17 -0400
Date: Tue, 8 May 2007 08:43:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070508064316.GF4226@stusta.de>
References: <20070507145555.GG3883@mea-ext.zmailer.org> <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com> <20070507153511.GH3883@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070507153511.GH3883@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 06:35:11PM +0300, Matti Aarnio wrote:
> On Mon, May 07, 2007 at 11:03:54AM -0400, John Anthony Kazos Jr. wrote:
> > > In the  linux-kernel  -list subscribers domain popularity
> > > analysis I got following results:
> > > 
> > >    2101 gmail.com
> > >      49 googlemail.com
> > >      46 gmx.de
> .... 
> > How about some elitism here? Dedicate a certain number of streams to 
> > everything-except-gmail, so MTAs from the 21st century can get their mail 
> > faster, and set the rest on gmail-only. Slows down gmail and speeds up the 
> > rest?
> 
> No need.  gmail has done that slowing down all by themselves quite handily..
> 
> VGER has dedicated number of streams to gmail, and bigger pools to elsewere.
> The gmail parallelism-pool is configured so that daily message volume does
> usually make it thru in a day.  I would prefer it going much faster...
> 
> If you are interested to see VGER's queues and monitor gauges, they are viewable
> with tools at web-page:
> 
>    http://vger.kernel.org/z/
> 
> Most of what it tells is not easily understandable, and much needs deep internal
> system knowledge to be understood at all - but mostly the queue display is
> self-explanatory.
> 
>   /Matti Aarnio
> 
> PS: Contact address for VGER's postmasters is:  postmaster@vger.kernel.org

BTW (not related to gmail):
Are there any news regarding the buggy 451 handling in zmailer I'm 
reporting again and again that regularly results in every single 
linux-kernel message sent to me being delayed by up to 13 hours?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

