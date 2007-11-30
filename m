Return-Path: <linux-kernel-owner+w=401wt.eu-S934268AbXK3RK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbXK3RK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935543AbXK3RJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:09:37 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55429 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935155AbXK3RJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:09:35 -0500
Date: Fri, 30 Nov 2007 09:09:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more "generic"
In-Reply-To: <20071130111000.GA32431@elte.hu>
Message-ID: <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com>
 <20071130111000.GA32431@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> note that this did not apply cleanly to latest x86.git. Could you 
> double-check my merge fixups below?

This is a core change against Andrew's tree. It needs to go into mm and 
not into the x86 tree. It is no surprise that this does not apply cleanly 
to the x86 tree.


