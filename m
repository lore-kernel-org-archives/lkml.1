Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXF0DSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXF0DSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXF0DSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:18:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48858 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760024AbXF0DSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:18:38 -0400
Date: Tue, 26 Jun 2007 20:18:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@google.com>
cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <20070626152204.b6b4bc3f.akpm@google.com>
Message-ID: <Pine.LNX.4.64.0706262017260.24504@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
 <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
 <20070626152204.b6b4bc3f.akpm@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> Is in my queue somewhere.  Could be that by the time I get to it it will
> need refreshing (again), we'll see.
> 
> One open question is the interaction between these changes and with Peter's
> per-device-dirty-throttling changes.  They also are in my queue somewhere. 
> Having a 100:1 coder:reviewer ratio doesn't exactly make for swift
> progress.

Hmmmm.. How can we help? I can look at some aspects of Peter's per device 
throttling.

