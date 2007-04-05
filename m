Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXDEAaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXDEAaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXDEAaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:30:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35685 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932184AbXDEAai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:30:38 -0400
Date: Wed, 4 Apr 2007 17:30:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
In-Reply-To: <20070404191205.392155702@goop.org>
Message-ID: <Pine.LNX.4.64.0704041729300.22161@schroedinger.engr.sgi.com>
References: <20070404191151.009821039@goop.org> <20070404191205.392155702@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Christoph Lameter <clameter@sgi.com>

for all thats worth since I am not a i386 specialist.

How much of the issues with page struct sharing between slab and arch code 
does this address?

