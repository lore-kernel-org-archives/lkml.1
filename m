Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYAHWWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYAHWWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbYAHWWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:22:39 -0500
Received: from relay1.sgi.com ([192.48.171.29]:34838 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756080AbYAHWWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:22:38 -0500
Date: Tue, 8 Jan 2008 14:22:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
In-Reply-To: <20080108210002.638347207@redhat.com>
Message-ID: <Pine.LNX.4.64.0801081421530.4281@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com> <20080108210002.638347207@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It may be good to coordinate this with Andrea Arcangeli's OOM fixes.

Also would it be possible to create generic functions that can move pages 
in pagevecs to an arbitrary lru list?


