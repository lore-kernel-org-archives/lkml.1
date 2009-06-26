Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZFZLk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZFZLk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFZLkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:40:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54465 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbZFZLkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:40:51 -0400
Date: Fri, 26 Jun 2009 12:41:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626124153.5dae8e3a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626104703.GA12446@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
	<20090626072218.GH14078@elte.hu>
	<20090626101446.114edbe2@lxorguk.ukuu.org.uk>
	<20090626094514.GB12571@elte.hu>
	<20090626111731.539f963e@lxorguk.ukuu.org.uk>
	<20090626104703.GA12446@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 12:47:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Which bit is not clear? We've been continuously 'driverizing' 
> > > the
> > 
> > What do you mean by "driverizing". You keep using your made up 
> > word but since nobody else knows what you mean its not productive 
> > to have the discussion using invented terms like that.
> 
> Yeah, it's a made up shortcut for "turning previously monolithic 
> code into structured, driver-alike code with a driver data 
> structure, possible data fields and function callbacks". See the x86 
> examples i cited.

ITYM Object orientation ?

So do you want a PPC like platform object or some kind of platform object
that creates timer and other objects which are separate ?

