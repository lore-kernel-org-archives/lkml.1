Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXGCU6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXGCU6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXGCU6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:58:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbXGCU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:58:37 -0400
Date: Tue, 3 Jul 2007 13:57:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andre Noll <maan@systemlinux.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.22-rc7: known regressions with patches
In-Reply-To: <468A7D24.3040004@googlemail.com>
Message-ID: <alpine.LFD.0.98.0707031356420.9434@woody.linux-foundation.org>
References: <468A7D24.3040004@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jul 2007, Michal Piotrowski wrote:
> 
> Subject         : inconsistent lock state
> References      : http://lkml.org/lkml/2007/7/3/195
> Last known good : ?
> Submitter       : Andre Noll <maan@systemlinux.org>
> Caused-By       : ?
> Handled-By      : Linus Torvalds <torvalds@linux-foundation.org>
>                   Christoph Lameter <clameter@sgi.com>
> Patch           : http://lkml.org/lkml/2007/7/3/214
> Status          : patch available

Ok, this one has been tested, committed, and pushed out.

		Linus
