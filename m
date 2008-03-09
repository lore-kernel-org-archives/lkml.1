Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYCIVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYCIVcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYCIVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:32:45 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:38880 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYCIVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:32:45 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
References: <20080309200103.GA895@mailshack.com>
	<20080309201016.GA28454@elte.hu> <87ve3vzk29.fsf@basil.nowhere.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 22:32:42 +0100
In-Reply-To: <87ve3vzk29.fsf@basil.nowhere.org>
Message-ID: <87iqzvzipx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 21:26:11.0153 (UTC) FILETIME=[32253410:01C8822C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> 
> I had a patchkit some time ago to special case the max_bit <= 63 case

... never mind ... the patchkit is actually included. I had only
dropped it at some point, but fixed later.

-Andi
