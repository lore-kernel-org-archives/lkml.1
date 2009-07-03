Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZGCSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZGCSic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZGCSiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:38:23 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:57106 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbZGCSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:38:23 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 13:38:22 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907031314.36243.lkml@morethan.org> <87fxddaafv.fsf@basil.nowhere.org>
In-Reply-To: <87fxddaafv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031338.24778.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, Andi Kleen wrote:
> "Michael S. Zick" <lkml@morethan.org> writes:
> 
> > Here is one I have found useful in my VIA processor bug hunting:
> 
> Could you please expand a bit what bug this is supposed to fix?
> 

I make no claims for it at the moment - too early in the test process.
Just the general observation that it takes 0.5M to describe 0.5G of ram.

Also, 
the observation that (1<<32) drops the bit off the left end of a 32-bit value.
You can see the result in the portion of the post you snipped out.  ;)

Mike
> -Andi
> 


