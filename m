Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbZG3PtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbZG3PtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZG3PtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:49:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZG3PtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:49:05 -0400
Date: Thu, 30 Jul 2009 17:49:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jun Koi <junkoi2004@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Firewire debugging tools - firedump & fireproxy?
Message-ID: <20090730154904.GD4534@basil.fritz.box>
References: <fdaac4d50907042242s6534d63at12a26df47a0f3b2a@mail.gmail.com> <87k51qfqve.fsf@basil.nowhere.org> <1248968242.3624.28.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248968242.3624.28.camel@maxim-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't know what to say about what I could do to help...
> I could help to make this tool better, don't know how much time will
> permit me, or at least I think that kgdbom can be merged almost as is
> already.

Cleaning up the patch and submitting it would be great yes.

One problem with firewire as it stands is that it doesn't support
more 4GB of memory and doesn't work with IOMMUs. But for limited
situations it's quite good.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
