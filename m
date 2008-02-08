Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbYBHUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbYBHUZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762041AbYBHUZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:25:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:58599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755210AbYBHUZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:25:24 -0500
Date: Fri, 8 Feb 2008 12:25:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/slub.c - Use print_hex_dump
In-Reply-To: <1202501739.27394.96.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802081224100.5358@schroedinger.engr.sgi.com>
References: <1202493808.27394.76.camel@localhost> 
 <Pine.LNX.4.64.0802081006460.28568@schroedinger.engr.sgi.com> 
 <1202495069.27394.85.camel@localhost>  <Pine.LNX.4.64.0802081031320.28862@schroedinger.engr.sgi.com>
 <1202501739.27394.96.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh. You need to cut that into small pieces so that it is easier to 
review. CCing Randy who was involved with prior art in this area.



