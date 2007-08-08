Return-Path: <linux-kernel-owner+w=401wt.eu-S937247AbXHHX1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937247AbXHHX1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936978AbXHHX1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:27:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53158 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936979AbXHHX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:27:03 -0400
Date: Wed, 8 Aug 2007 16:26:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
 zonelists v2
In-Reply-To: <20070808210429.GA32462@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708081626420.17224@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0708081025330.12652@schroedinger.engr.sgi.com>
 <20070808210429.GA32462@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Mel Gorman wrote:

> I'll revisit it again just in case but for now I'd rather not get
> sidetracked from the patchset at hand.

Sure. This is more long term.

