Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbXJLTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbXJLTiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXJLTiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:38:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1783 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXJLTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:37:59 -0400
Date: Fri, 12 Oct 2007 20:37:51 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: "Mike D. Day" <ncmike@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Erez Zadok <ezk@cs.sunysb.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Fix line number reporting
Message-ID: <20071012193751.GA31579@shadowen.org>
References: <20071012192654.GB18901@silverwood.ncultra.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012192654.GB18901@silverwood.ncultra.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 03:26:54PM -0400, Mike D. Day wrote:
> Fix line number reporting when checking source files (as opposed to
> patches)
> 
> Signed-off-by: Mike D. Day <ncmike@us.ibm.com>

Sorry you've had to fix this about 4 times, mostly because of ongoing
changes, and slow replication getting in the way.  I've applied this
and you should find it in -next when replication hits.  md5sum is
below of the version with it in, so you can make sure you've got
the right one.

54f053c50265e44a6041e3147dc66a69  checkpatch.pl

-apw
