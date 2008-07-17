Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYGQGkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYGQGkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYGQGkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:40:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44507 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYGQGkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:40:06 -0400
Message-ID: <487EE940.1050007@firstfloor.org>
Date: Thu, 17 Jul 2008 08:40:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linuxfoundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 Jul 2008, Jesse Barnes wrote:
>> Yeah, they're interdependent (I pulled from Len's tree, hopefully Andi 
>> preserved the changesets).
> 
> Andi did not. The whole series I pulled was rebased today at 2PM.
> 
> I was going to complain about it, because Len's trees were always a 
> pleasure to pull with clearly delineated topic branches etc, and pulling 
> from Andi was such a let-down in comparison.

I went back to quilt because the topic branches didn't really
work out for me.

> But I decided to let it slide, because quite frankly, Len had done better 
> than the average bear, and I didn't realize that the commits Andi had 
> rebased had actually been in Len's tree in the _good_ format.
> 
> It seems I was wrong - I should _not_ have let it slide, and it appears 
> that Andi had actually destroyed Len's pretty tree.

My plan was to keep everything in quilt and just regenerate for the pull.
Please let me know if it's now not allowed anymore to use quilt.

-Andi
