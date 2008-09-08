Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYIHWnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYIHWnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYIHWnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:43:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYIHWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:43:30 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
From: Andi Kleen <andi@firstfloor.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org>
Date: Tue, 09 Sep 2008 00:43:31 +0200
In-Reply-To: <20080908114619.741b6786@infradead.org> (Arjan van de Ven's message of "Mon, 8 Sep 2008 11:46:19 -0700")
Message-ID: <87prnetg18.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Mon, 08 Sep 2008 11:22:24 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> 
>> The "ideal" way to do any of this would probably to have checkboxes
>> for all the CPUs you want to support and then a drop-down box for the
>> CPU to optimize for.  However, the combinatorics of that would be
>> horrible, and it would be very unlikely we would avoid bugs.
>
> the ideal case would be "support them all"

Support all from the last 10 years (ok excluding legacy models that
just shipped forever like 486). I think that's quite reasonable
to do and worked for a long time.

-Andi
-- 
ak@linux.intel.com
