Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYE3GRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYE3GRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYE3GQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:16:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33393 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754016AbYE3GQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:16:42 -0400
Date: Thu, 29 May 2008 23:16:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <20080530145612.fd930335.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0805292316190.12457@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <20080529215833.469c3cbe.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292203240.12107@schroedinger.engr.sgi.com>
 <20080530145612.fd930335.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, KAMEZAWA Hiroyuki wrote:

> 30000 is suitable for both of 32bits/64bits arch ?

Was developed on 64bit. As ususal 32 bit was an afterthought.

