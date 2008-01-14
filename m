Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYANWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYANWHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbYANWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:07:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYANWHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:07:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
Date: Mon, 14 Jan 2008 23:09:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: dds@google.com, pavel@ucw.cz, shpedoikal@gmail.com, tpm@selhorst.net,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <477D491F.1060001@selhorst.net> <200801142240.59174.rjw@sisk.pl> <20080114135223.bcee353a.akpm@linux-foundation.org>
In-Reply-To: <20080114135223.bcee353a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801142309.39483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of January 2008, Andrew Morton wrote:
> On Mon, 14 Jan 2008 22:40:58 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > >
> > > > Yep, but please fix the whitespace.
> > > > 									Pavel
> > > 
> > > OK, attached.
> > 
> > Is anyone taking care of this patch or should I do that?
> 
> Linus just merged it as 2490c681ea3d7f5ac3fb876f14567bf1a9e0aa87.  That's
> if we're talking about the same thing (there were a few iterations). 

Yes, that's the same thing, thanks.
