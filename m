Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0APLHV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212Ab0APLHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:07:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0APLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:07:17 -0500
Date: Sat, 16 Jan 2010 12:07:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow linker to eliminate unused functions in lib/*
Message-ID: <20100116110703.GA12881@basil.fritz.box>
References: <20100105145917.GA25570@basil.fritz.box> <20100108162930.a011749a.akpm@linux-foundation.org> <20100109165155.GD20773@basil.fritz.box> <20100115154404.da44ba5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115154404.da44ba5a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll drop 
> 
> lib-allow-linker-to-eliminate-unused-functions.patch
> lib-allow-linker-to-eliminate-unused-functions-fix.patch
> lib-allow-linker-to-eliminate-unused-functions-fix-2.patch
> 
> for now and will return the patch for warranty repairs, please.

Ok. I'll double check allno and allmod and send a new patch. 

Sorry for the trouble

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
