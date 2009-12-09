Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZLIJN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZLIJN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZLIJNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:13:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47165 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbZLIJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:13:22 -0500
Date: Wed, 9 Dec 2009 10:13:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: hwpoison tree build failure
Message-ID: <20091209091325.GD18989@one.firstfloor.org>
References: <20091208191418.79270012.sfr@canb.auug.org.au> <20091208095147.GS18989@one.firstfloor.org> <20091209102547.c6f03d75.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209102547.c6f03d75.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 10:25:47AM +1100, Stephen Rothwell wrote:
> Hi Andi,
> 
> On Tue, 8 Dec 2009 10:51:47 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Ah these symbols need to be exported and made sure to be enabled
> > in the Kconfig. Thanks I'll fix and push out a new tree.
> 
> Thanks.

The problem was solved in a different way, but it should compile
in any case.
-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
