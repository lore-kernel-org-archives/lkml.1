Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZJ0OAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZJ0OAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZJ0OAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:00:14 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:45035
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbZJ0OAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:00:13 -0400
Date: Tue, 27 Oct 2009 15:00:07 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091027140007.GA27672@gibson.comsick.at>
References: <20091027095014.GA22215@gibson.comsick.at>
 <200910271138.01624.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910271138.01624.elendil@planet.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Oct 09 11:38, Frans Pop wrote:
> Michael Guntsche wrote:
> > I noticed that I get page alloc errors on one of my machines.
> > It is an old server I use as a fileserver with 512MB RAM. Before
> > 2.6.3[12] I did not see this problem at all.
> This is a known issue that's being heavily investigated, but is proving 
> very elusive. See http://lkml.org/lkml/2009/10/22/128 for an overview.
> 
> Can you easily reproduce the problem, or does it happen at random moments? 
> If you can reproduce it, it would be great if you could test the patches 
> mentioned in that mail.
Hello Frans,

Thanks for the info. I will try to reproduce it with those patches
applied. But it happens randomly I had no problems for several days now
just saw it again yesterday. Nevertheless I see if those patches help
and will report back.

Michael
