Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbYG1RlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbYG1RlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbYG1RlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:41:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60089 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYG1RlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:41:03 -0400
Date: Mon, 28 Jul 2008 19:40:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] more sysdev API change fallout - drivers/base/memory.c
Message-ID: <20080728174051.GB30344@one.firstfloor.org>
References: <20080728110504.41531146.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728110504.41531146.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:05:04AM +1000, Stephen Rothwell wrote:
> Noticed because of this warning:
> 
> drivers/base/memory.c:279: warning: initialization from incompatible
> pointer type

Thanks. Someone else also had submitted a patch for this, so it might
be already queued.

-Andi
