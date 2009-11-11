Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZKKVrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZKKVrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759391AbZKKVrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:47:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52946 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390AbZKKVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:47:11 -0500
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
From: Andi Kleen <andi@firstfloor.org>
References: <81bfc67a0910310721p21046931o9b512cfd0a8a7acb@mail.gmail.com>
	<200910311944.35922.elendil@planet.nl>
	<81bfc67a0911111219m1efff30cr3186987f9dbb3d4d@mail.gmail.com>
Date: Wed, 11 Nov 2009 22:47:15 +0100
In-Reply-To: <81bfc67a0911111219m1efff30cr3186987f9dbb3d4d@mail.gmail.com> (Caleb Cushing's message of "Wed, 11 Nov 2009 15:19:54 -0500")
Message-ID: <878wecka3g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caleb Cushing <xenoterracide@gmail.com> writes:
>>
>> I'm attaching the bisection log and a 'good' dmesg output.
>>
>> c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9 is the first bad commit

Just gives fatal: bad object c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
here on a standard Linus linux-2.6 tree.

It might be also useful if you could describe what kind
of network devices you use and how you determine
the packet loss.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
