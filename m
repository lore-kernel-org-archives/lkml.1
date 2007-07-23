Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbXGWWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbXGWWLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXGWWKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:10:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbXGWWKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:10:48 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/2] faking and fixing the NUMA SLIT
Date: Mon, 23 Jul 2007 18:10:32 -0400
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, "Joachim Deguara" <joachim.deguara@amd.com>,
       "lkml List" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       travis@sgi.com, steiner@sgi.com
References: <200707181130.01861.joachim.deguara@amd.com> <200707181142.20811.ak@suse.de> <20070723132526.5ce87f0d@schroedinger.engr.sgi.com>
In-Reply-To: <20070723132526.5ce87f0d@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231810.32983.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 16:25, Christoph Lameter wrote:
> On Wed, 18 Jul 2007 11:42:20 +0200
> Andi Kleen <ak@suse.de> wrote:
> 
> > Don't think that is really useful.
> 
> I think this is useful for NUMA debugging since one may use this to
> create various slit configuration that can be useful to simulate many
> fallback scenarios that may require testing.

Why not build a new SLIT into the kernel for the test
to override the BIOS -- like we do when we want a test version of the DSDT?

-Len

