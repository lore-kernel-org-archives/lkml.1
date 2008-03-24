Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYCXWdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYCXWdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYCXWdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:33:33 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:33294 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYCXWdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:33:33 -0400
From: Chr <chunkeey@web.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: inotify fixes in stable
Date: Mon, 24 Mar 2008 23:33:29 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       stable@kernel.org
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <20080310211346.GA6622@kroah.com> <200803111512.37605.nickpiggin@yahoo.com.au>
In-Reply-To: <200803111512.37605.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242333.30200.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/31JDNEpY7Q8G9pKWj/cvShPc4Hg69IZL+1QP+
	XrhMt2iKHq/VB0ejngHRVCOOXbdVegOjDLB9fLhIpsLsbnQLgm
	W7aEKLObc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 05:12:37 Nick Piggin wrote:
>
> The messages should actually be harmless. There is a race in the debug
> code that can trigger them. But I wouldn't object to the patches going
> to -stable...
>
let me guess... the patch didn't get into 2.6.24.4, right? because I still
get these noisy "WARNING: at fs/inotify.c:172 set_dentry_child_flags()"
and probably alot of other kde4 users too?!

Regards,
	Christian


