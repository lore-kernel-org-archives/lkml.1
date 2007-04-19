Return-Path: <linux-kernel-owner+w=401wt.eu-S1031090AbXDSCz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031090AbXDSCz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 22:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031094AbXDSCz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 22:55:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36070 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031090AbXDSCz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 22:55:29 -0400
Date: Wed, 18 Apr 2007 19:55:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <4626CEDA.7050608@google.com>
Message-ID: <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
 <4626CEDA.7050608@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Ethan Solomita wrote:

>    Any new ETA? I'm trying to decide whether to go back to your original
> patches or wait for the new set. Adding new knobs isn't as important to me as
> having something that fixes the core problem, so hopefully this isn't waiting
> on them. They could always be patches on top of your core patches.
>    -- Ethan

Hmmmm.... Sorry. I got distracted and I have sent them to Kame-san who was 
interested in working on them. 

I have placed the most recent version at
http://ftp.kernel.org/pub/linux/kernel/people/christoph/cpuset_dirty

