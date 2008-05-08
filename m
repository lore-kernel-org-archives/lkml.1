Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYEHL6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYEHL6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYEHL57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:57:59 -0400
Received: from laney.dpool.org ([78.47.134.123]:3829 "EHLO mail1.s.dpool.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYEHL56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:57:58 -0400
Message-ID: <4822EAC2.5010502@elsdoerfer.info>
Date: Thu, 08 May 2008 13:57:54 +0200
From: =?UTF-8?B?TWljaGFlbCBFbHNkw7ZyZmVy?= <michael@elsdoerfer.info>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Cannot boot any HIGHMEM kernel (kernel panic - not syncing)
References: <4822DDF1.5010500@elsdoerfer.info> <87od7h9g1s.fsf@basil.nowhere.org>
In-Reply-To: <87od7h9g1s.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >> Now, Machine Check Exception seems to point towards a hardware error,
 >
 > It not only seems to, it does.
 > The non highmem kernel will simply not use most of your memory, so if
 > the machine check happens accessing memory you will not see it.

Thanks Andi.

So the problem would be defective RAM in the machine?

I'm still wondering though while the previous kernel (a self-compiled 
2.6.17.11) worked then. Laxer checks?

Michael
