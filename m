Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYHONfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYHONfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYHONfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:35:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYHONfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:35:05 -0400
Date: Fri, 15 Aug 2008 15:36:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix /proc/meminfo DirectMap
Message-ID: <20080815133632.GI19125@one.firstfloor.org>
References: <Pine.LNX.4.64.0808151351220.28840@blonde.site> <20080815131530.GG19125@one.firstfloor.org> <Pine.LNX.4.64.0808151426080.309@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151426080.309@blonde.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, that's what I meant by the TLB optimizers.  But it's going to
> be a fractional effect, isn't it, when you're trying to get the last
> 1% out of the machine?  

Depending on the workload it can be much more than that.

-Andi
