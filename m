Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbXEaWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbXEaWIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXEaWIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:08:37 -0400
Received: from palrel13.hp.com ([156.153.255.238]:42377 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbXEaWIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:08:37 -0400
Date: Thu, 31 May 2007 17:08:33 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
Message-ID: <20070531220833.GA10867@beardog.cca.cpqcorp.net>
References: <465C188F.9000900@googlemail.com> <465C22F4.8080505@googlemail.com> <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 07:22:14PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 May 2007, Michal Piotrowski wrote:
> > 
> > Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
> > References : http://lkml.org/lkml/2007/5/24/172
> > Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
> > Status     : Unknown
> 
> I thought this one should be fixed by commit e9ca75b53. Not so?
> 
> Mike?
> 
> 			Linus

I apologize for the slow response. I also apologize that I don't know enough
about git to figure out what commit e9ca75b53 does. I submitted a fix that
was blessed by Eric B. that fixed that Oops. 

mikem
