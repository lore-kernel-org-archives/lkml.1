Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZAFE2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZAFE2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZAFE2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:28:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZAFE2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:28:00 -0500
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: Andi Kleen <andi@firstfloor.org>
References: <20090105.183106.252630446.davem@davemloft.net>
	<alpine.LFD.2.00.0901051839330.3057@localhost.localdomain>
	<20090105.201530.195720489.davem@davemloft.net>
Date: Tue, 06 Jan 2009 05:27:58 +0100
In-Reply-To: <20090105.201530.195720489.davem@davemloft.net> (David Miller's message of "Mon, 05 Jan 2009 20:15:30 -0800 (PST)")
Message-ID: <871vvhdpo1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> The default is extremely strict, which makes me check things out by
> hand.  That's good, but as I add the change by hand after verifying
> it's sanity I often make mistakes that result in things like the above
> missed delete, so if I could ask git to be non-strict it would help me
> out a lot.

Sorry for the me too, but I would really love to have such a feature
too.

-Andi


-- 
ak@linux.intel.com
