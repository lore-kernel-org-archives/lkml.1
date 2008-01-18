Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbYARGBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbYARGBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYARGB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:01:26 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:57356 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYARGBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:01:25 -0500
Date: Fri, 18 Jan 2008 01:01:24 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
Message-ID: <20080118060124.GC1726@phobos.i.cabal.ca>
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p734pdbbrwu.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:53:53AM +0100, Andi Kleen wrote:
> One problem that we had in the past is that some simulators
> only implement the absolutely minimum feature set and you
> might have well broken one of these with this.

Yeah, true. Please ignore the patch folks.

cheers,	Kyle
