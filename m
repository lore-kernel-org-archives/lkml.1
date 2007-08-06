Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXHFUN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXHFUN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbXHFUNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:13:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59277 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764657AbXHFUNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:13:43 -0400
Date: Mon, 6 Aug 2007 13:13:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@skynet.ie>, pj@sgi.com, Lee.Schermerhorn@hp.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
In-Reply-To: <20070806124408.16034ab8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708061313270.7603@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie>
 <Pine.LNX.4.64.0708021343420.10244@schroedinger.engr.sgi.com>
 <20070806124408.16034ab8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andrew Morton wrote:

> Which Paul?

Paul Jackson. 

