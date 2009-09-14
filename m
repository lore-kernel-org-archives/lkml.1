Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbZINSXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbZINSXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbZINSXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:23:14 -0400
Received: from fifo99.com ([67.223.236.141]:52251 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbZINSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:23:12 -0400
Subject: Re: [PATCH 0/5] kernel handling of dynamic logical partitioning
From: Daniel Walker <dwalker@fifo99.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4AAE89CE.2030804@austin.ibm.com>
References: <4AAABC55.4070207@austin.ibm.com>
	 <1252704198.28368.31.camel@desktop>  <4AAE89CE.2030804@austin.ibm.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 11:24:00 -0700
Message-Id: <1252952640.11643.64.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 13:22 -0500, Nathan Fontenot wrote:
> Daniel Walker wrote:
> > On Fri, 2009-09-11 at 16:08 -0500, Nathan Fontenot wrote:
> >>  am cc'ing lkml.
> >>
> >> Patches include in this set:
> >> 1/5 - DLPAR infrastructure for powerpc/pseries platform.
> >> 2/5 - Move the of_drconf_cell struct to prom.h
> >> 3/5 - Export the memory sysdev class
> >> 4/5 - Memory DLPAR handling
> >> 5/5 - CPU DLPAR handling
> >>
> > 
> > It looks like a couple of your patches have some checkpatch issues..
> > Could you run these through scripts/checkpatch.pl and clean up any
> > problems it raises ? Specifically patches 1, 4, and 5 ..
> > 
> 
> thanks for checking this, I obviously forgot.  I'll post updated patches
> (after running checkpatch on them) with fixes.

Ok, thanks..

Daniel

