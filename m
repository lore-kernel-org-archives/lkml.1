Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYGPXqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYGPXqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYGPXqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:46:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbYGPXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:46:11 -0400
Date: Wed, 16 Jul 2008 16:45:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linuxfoundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <200807161633.01375.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Jesse Barnes wrote:
> 
> Yeah, they're interdependent (I pulled from Len's tree, hopefully Andi 
> preserved the changesets).

Andi did not. The whole series I pulled was rebased today at 2PM.

I was going to complain about it, because Len's trees were always a 
pleasure to pull with clearly delineated topic branches etc, and pulling 
from Andi was such a let-down in comparison.

But I decided to let it slide, because quite frankly, Len had done better 
than the average bear, and I didn't realize that the commits Andi had 
rebased had actually been in Len's tree in the _good_ format.

It seems I was wrong - I should _not_ have let it slide, and it appears 
that Andi had actually destroyed Len's pretty tree.

Andi. This can _not_ continue. You need to learn how to use topic 
branches, and how to not screw up other peoples trees. Otherwise I'll just 
have to stop pulling from you. AGAIN.

			Linus
