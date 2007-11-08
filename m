Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbXKHU2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbXKHU2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbXKHU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:28:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49380 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761151AbXKHU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:28:17 -0500
Date: Thu, 8 Nov 2007 12:28:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundatin.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/23] Slab defragmentation V6
In-Reply-To: <20071108202429.GF23882@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711081226550.10291@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <1194535612.6214.9.camel@localhost>
 <Pine.LNX.4.64.0711081103360.8954@schroedinger.engr.sgi.com>
 <20071108202429.GF23882@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Mel Gorman wrote:

> It certainly can be tried out. However, this is a future problem and
> independent of the current patchset. I don't want to drag us down a blind
> alley about a problem that isn't even at hand.

Right. That is why I took it out.
 
