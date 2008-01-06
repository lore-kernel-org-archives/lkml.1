Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYAFNjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYAFNjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYAFNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:39:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbYAFNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:39:27 -0500
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080106131343.GA3120@lazybastard.org>
References: <200801060717.m067HW6c030422@agora.fsl.cs.sunysb.edu>
	 <20080106131343.GA3120@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 06 Jan 2008 14:39:22 +0100
Message-Id: <1199626763.31975.50.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 14:13 +0100, Jörn Engel wrote:

> Ingo, Peter, does either of you actually care about this problem?  In
> the last round when I debugged this problem there was a notable lack of
> reaction from either of you.

Yeah I do, I just know very little about the module stuff and haven't
come around to looking into it.

I agree that Erez's patch is quite horrible.

