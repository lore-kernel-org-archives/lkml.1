Return-Path: <linux-kernel-owner+w=401wt.eu-S1765953AbXHIVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765953AbXHIVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXHIVTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:19:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36570 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbXHIVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:19:05 -0400
Date: Thu, 9 Aug 2007 14:19:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] Use one zonelist per node instead of multiple
 zonelists v3
In-Reply-To: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708091418470.32324@schroedinger.engr.sgi.com>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Mel Gorman wrote:

> o Encode zone_id in the zonelist pointers to avoid zone_idx() (Christoph's idea)

That is addressed by this patch it seems?
