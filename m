Return-Path: <linux-kernel-owner+w=401wt.eu-S2992988AbXDYTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992988AbXDYTo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993003AbXDYTo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:44:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:60288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992988AbXDYToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:44:00 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
Date: Wed, 25 Apr 2007 21:43:48 +0200
User-Agent: KMail/1.9.6
Cc: Ian Pratt <ian.pratt@xensource.com>, lkml <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070423215638.563901986@goop.org> <200704251112.45898.ak@suse.de> <462FAEE3.9090900@goop.org>
In-Reply-To: <462FAEE3.9090900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252143.48363.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 21:41:23 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >> ... will review the rest later.
> >>     
> >
> > Rest is ok
> >   
> 
> Thanks for looking at it.  I'll try to separate xen-core into more
> digestable pieces.

For me you don't need anymore, but possibly for others.

To summarize the outstanding issues are:
- fixing sched_clock first
- hopefully more review of the core pieces by others
- what i commented (minor stuff mostly)
- review of xenbus and drivers
[i did upto the grant table code, but not more] 


-Andi
