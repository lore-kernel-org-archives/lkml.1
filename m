Return-Path: <linux-kernel-owner+w=401wt.eu-S937228AbXHLR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937228AbXHLR5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758560AbXHLR5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:57:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757354AbXHLR5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:57:39 -0400
Date: Sun, 12 Aug 2007 10:57:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Petr Vandrovec <petr@vandrovec.name>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: Please remove ab144f5ec64c42218a555ec1dbde6b60cf2982d6 was Re:
 [discuss] [PATCH] Fix triplefault on x86-64 bootup
In-Reply-To: <p731we8kgbd.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.999.0708121057010.30176@woody.linux-foundation.org>
References: <20070812081252.GA23309@vana.vc.cvut.cz> <200708121209.40995.ak@suse.de>
 <46BEE427.3020904@vandrovec.name> <p731we8kgbd.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Aug 2007, Andi Kleen wrote:
> 
> Can you double check? I have a hard time believing it.

Andi, read the code. The old code was fine. Your patch was the culprit.

		Linus
