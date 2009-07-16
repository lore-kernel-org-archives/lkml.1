Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbZGPRDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbZGPRDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbZGPRDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:03:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46094 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbZGPRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:03:09 -0400
Date: Thu, 16 Jul 2009 10:03:10 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Noah Watkins <jayhawk@soe.ucsc.edu>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
In-Reply-To: <20090716035929.GA23145@martini>
Message-ID: <Pine.LNX.4.64.0907160958520.8026@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <20090716035929.GA23145@martini>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009, Noah Watkins wrote:
> On Wed, Jul 15, 2009 at 02:24:30PM -0700, Sage Weil wrote:
> > 
> > A git tree containing just the client (and this patch series) is at
> > 	git://ceph.newdream.net/linux-ceph-client.git
> 
> Sage,
> 
> Do you maintain a Git kernel tree with the Ceph kernel client that 
> tracks mainline?

Up until now the tree has been rebuilt from the main git repo each time I 
generate and send out the patchset.  The plan is to move the client code 
development into that kernel tree once it's ready to merge, and mirror 
just fs/ceph/* changes in a 'standalone' tree (ceph-client.git).

In the meantime, I can put something together to mirror the client code 
changes in the linux-ceph-client.git tree, if there's any demand for it...

sage
