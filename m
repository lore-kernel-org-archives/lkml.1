Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZE0AEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZE0AEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbZE0AEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:04:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36700 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbZE0AEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:04:31 -0400
Date: Wed, 27 May 2009 02:11:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527001104.GN846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org> <20090526231428.GK846@one.firstfloor.org> <20090526162821.02e11d5b.akpm@linux-foundation.org> <20090526234109.GL846@one.firstfloor.org> <20090526164532.6c780234.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526164532.6c780234.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I dunno.  Is this true of all linux filesystems in all cases?  Maybe.

Assuming one of them is not would you rather want to fix that file system
or 10 zillion user programs (including the kernel core dumper) that 
get it wrong? @)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
