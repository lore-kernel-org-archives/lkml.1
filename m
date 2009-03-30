Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbZC3MmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbZC3MmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZC3Ml7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:41:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZC3Ml6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:41:58 -0400
Date: Mon, 30 Mar 2009 14:43:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 09/14] fs: use RCU / seqlock logic for reverse and multi-step operaitons
Message-ID: <20090330124328.GJ11935@one.firstfloor.org>
References: <20090329155539.275927173@nick.local0.net> <20090329155749.609663166@nick.local0.net> <874oxbnr2m.fsf@basil.nowhere.org> <20090330122902.GG31000@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330122902.GG31000@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that I *think* the idea is pretty sound, but I'm just not

Sorry didn't want to sound negative. Just more testing is always
good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
