Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbXHANnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbXHANnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbXHANnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:43:31 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58793 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760276AbXHANnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:43:31 -0400
Date: Wed, 1 Aug 2007 09:43:30 -0400
To: Cal Peake <cp@absolutedigital.net>
Cc: "Brian D. McGrew" <brian@visionpro.com>, linux-kernel@vger.kernel.org
Subject: Re: Multiple CD-ROM Drives
Message-ID: <20070801134330.GB14084@csclub.uwaterloo.ca>
References: <14CFC56C96D8554AA0B8969DB825FEA0037FAEEB@chicken.machinevisionproducts.com> <Pine.LNX.4.64.0707311706080.13917@lancer.cnet.absolutedigital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707311706080.13917@lancer.cnet.absolutedigital.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 05:08:19PM -0400, Cal Peake wrote:
> On Mon, 30 Jul 2007, Brian D. McGrew wrote:
> 
> > Using FC5 with a 2.6.15 kernel my system (Dell Optiplex) see both
> > drives.
> > 
> > Using the 2.6.16.16 kernel that I've built I see no CD-ROM drives.
> > 
> > What could I have missed in the configuration?
> 
> Maybe send your working and broken configs to be examined? :)

Maybe it needs atapi enabled on libata.  I used to have that problem
with lots of Dell systems.  Supposedly FC5 had that enabled, while
2.6.16 did not.  2.6.18 and higher supposedly has it enabled now.

--
Len Sorensen
