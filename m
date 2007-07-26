Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbXGZR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbXGZR67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763125AbXGZR6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:58:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59776 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763405AbXGZR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:58:51 -0400
Date: Thu, 26 Jul 2007 10:58:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, ak@suse.de, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: bind_zonelist() - are we definitely sizing this correctly?
In-Reply-To: <20070726142550.GA14891@skynet.ie>
Message-ID: <Pine.LNX.4.64.0707261057480.2374@schroedinger.engr.sgi.com>
References: <20070726141756.GB18825@skynet.ie> <20070726142550.GA14891@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Mel Gorman wrote:

> This could have done with a comment.

See the exhaustive description by Paul include/linux/mmzone.h

