Return-Path: <linux-kernel-owner+w=401wt.eu-S1763471AbYDVOJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763471AbYDVOJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYDVOJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:09:16 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:35749 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYDVOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:09:15 -0400
Date: Tue, 22 Apr 2008 10:09:14 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Kyle McMartin <kyle@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 9/11] parisc: convert to generic helpers for IPI
	function calls
Message-ID: <20080422140914.GD19802@phobos.i.cabal.ca>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-10-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208851058-8500-10-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 09:57:35AM +0200, Jens Axboe wrote:
> This converts mips to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested,
> not even compiled.
> 

At first glance, this looks alright. +1 from me.

cheers, Kyle
