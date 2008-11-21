Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYKUHaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYKUHaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYKUHaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:30:05 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49935 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbYKUHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:30:04 -0500
X-Sasl-enc: JK6j4Sui1PbgaS73Ow2nWLSFgjLNkG+St5/jDyOe6wth 1227252602
Date: Fri, 21 Nov 2008 16:29:57 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Jan Blunck <jblunck@suse.de>
cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bharata@linux.vnet.ibm.com
Subject: Re: union mount status
In-Reply-To: <20081015191144.GJ29067@bolzano.suse.de>
Message-ID: <alpine.LFD.2.00.0811211627400.5827@zeus.themaw.net>
References: <48F51B6C.2080000@fr.ibm.com> <20081015191144.GJ29067@bolzano.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Jan Blunck wrote:

> On Wed, Oct 15, Daniel Lezcano wrote:
> 
> > Hi all,
> > 
> > What is the status of this patchset ?
> > Bharata Rao told me, no consensus was reached yet.
> > After looking at Jan Blunk's ftp server, it looks like the latest 
> > patchset was for 2.6.25-mm1. Is anyone working on this patchset right now ?
> 
> Not that I know of.
> 
> The state is as follows: we (David Woodhouse, Bharata Rao, Erez Zadok and me)
> agreed on a more or less final version of the whiteout patches. I haven't
> posted them yet since I know that Al Viro isn't convinced of the idea that
> they are actaully necessary. My plan was to solve the readdir() issues first,
> because they are the biggest roadblock IMHO. Bharata worked on some glibc
> readdir stuff but I don't know how that went.

I'm trying to work through applying your patches to a current kernel so I 
can have a decent look through them.
Do you have a more recent version of the patches?

What are your current thoughts on the readdir() problem?

Ian

