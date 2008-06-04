Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYFDIsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYFDIsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYFDIsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:48:13 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:47339 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYFDIsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:48:12 -0400
Date: Wed, 4 Jun 2008 04:48:11 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
cc: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Who can backport the AHCI driver to older kernels
In-Reply-To: <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
Message-ID: <alpine.DEB.1.10.0806040447291.5318@mtl.rackplans.net>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com> <200806031352.31940.elendil@planet.nl> <18501.13296.224958.291840@harpo.it.uu.se> <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Rainer Koenig wrote:

> Hi Mikael,
> 
> Am Dienstag, 3. Juni 2008 14:07 schrieb Mikael Pettersson:
> > Redhat seems to regularly backport the entire libata layer
> > to at least 2.6.18 (RHEL5) and maybe also 2.6.9 (RHEL4).
> 
> Yes indeed we get perfect support from both Red Hat and SUSE for their 
> enterprise level distribution. I already got a driver kit for the 
> SLES10 kernel. The problem is that the targeted market is not willing
> to use enterprise level (which means spend money for subscription) 
> distros. They go for the "free" (as in free beer) distros and suffer 
> from missing drivers. 
> 

Why not just create custom boot cds with the newer kernel for each distro?  
It seems like less work.

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
