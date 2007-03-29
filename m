Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbXC1XZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbXC1XZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbXC1XZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:25:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48022 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933846AbXC1XZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:25:21 -0400
Date: Thu, 29 Mar 2007 01:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070329012859.53bef09a@the-village.bc.nu>
In-Reply-To: <20070328220131.GF2986@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
	<20070328205055.GX8915@holomorphy.com>
	<Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
	<20070328212459.GY8915@holomorphy.com>
	<Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com>
	<20070328220131.GF2986@holomorphy.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 15:01:31 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> On Wed, Mar 28, 2007 at 02:38:55PM -0700, Christoph Lameter wrote:
> > No that was described in the patch. Quote:
> > "i386 only provides support for caching constructed pgd and pmds. These 
> > are comparatively rare to ptes so it is no surprise that the current 
> > approach has only minimal effect. ...."

Whatever it was originally for and public or not, the above isn't true
for some non Intel products...
