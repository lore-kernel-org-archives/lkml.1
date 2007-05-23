Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbXEWW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbXEWW1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXEWW13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:27:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40857 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755293AbXEWW13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:27:29 -0400
Date: Wed, 23 May 2007 15:27:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070523150122.f9946f37.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Andrew Morton wrote:

> argh, I never 100% understood the slab gobbledygook, and now we have slub
> gobbledygook.  I _hope_ what that's saying is that the 00 at 0xc90f6d28
> wasn't supposed to be there.

Exactly. I tried to make the SLUB gobbledygook better. Any other ideas on 
how to improve it?

