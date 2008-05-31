Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYEaHBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYEaHBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYEaHAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:00:51 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:49787 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYEaHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:00:50 -0400
Date: Sat, 31 May 2008 03:00:49 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com, Kyle McMartin <kyle@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 9/10] parisc: convert to generic helpers for IPI
	function calls
Message-ID: <20080531070049.GA6623@phobos.i.cabal.ca>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-10-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212051504-12561-10-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 10:58:23AM +0200, Jens Axboe wrote:
> This converts parisc to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested,
> not even compiled.
> 
> Cc: Kyle McMartin <kyle@parisc-linux.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>  

Do you have all this in an easily accessible git tree that I can merge
to test?

regards, Kyle
