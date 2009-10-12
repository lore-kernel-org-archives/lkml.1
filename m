Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZJLOlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZJLOlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZJLOll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZJLOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:41:40 -0400
Date: Mon, 12 Oct 2009 10:39:40 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "gabriele balducci" <balducci@units.it>
Subject: Re: [Bug #14275] kernel>=2.6.31: ahci.c: do not force
 unconditionally sb600 to 32bit dma any more?
Message-ID: <20091012103940.0433cb68@katamari.usersys.redhat.com>
In-Reply-To: <L6tb-VyKHZK.A.hHC.ezl0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.hHC.ezl0KB@chimera>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 01:01:09 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14275
> Subject		: kernel>=2.6.31: ahci.c: do not force unconditionally sb600 to 32bit dma any more?
> Submitter	: gabriele balducci <balducci@units.it>
> Date		: 2009-09-30 15:02 (12 days old)
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=14275#c0
> 

Already marked fixed in bugzilla.

Fixed by commit 2fcad9d271
("ahci: disable 64bit DMA by default on SB600s")

Not in 2.6.31-stable.
