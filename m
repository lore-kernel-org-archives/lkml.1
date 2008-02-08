Return-Path: <linux-kernel-owner+w=401wt.eu-S935674AbYBHSKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935674AbYBHSKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934703AbYBHSHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:07:41 -0500
Received: from relay1.sgi.com ([192.48.171.29]:34528 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932770AbYBHSHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:07:38 -0500
Date: Fri, 8 Feb 2008 10:07:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm/slub.c - Use print_hex_dump
In-Reply-To: <1202493808.27394.76.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com>
References: <1202493808.27394.76.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Joe Perches wrote:

> Use the library function to dump memory

Could you please compare the formatting of the output before and 
after? Last time we tried this we had issues because it became a bit ugly.

