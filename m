Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbXKLTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbXKLTSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXKLTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:18:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55600 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751599AbXKLTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:18:32 -0500
Date: Mon, 12 Nov 2007 11:18:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Denis Cheng <crquan@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: killed the unused "end" variable
In-Reply-To: <1194886182-2330-1-git-send-email-crquan@gmail.com>
Message-ID: <Pine.LNX.4.64.0711121118100.26682@schroedinger.engr.sgi.com>
References: <1194886182-2330-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Denis Cheng wrote:

> Since the macro "for_each_object" introduced, the "end" variable becomes unused anymore.

Acked-by: Christoph Lameter <clameter@sgi.com>
