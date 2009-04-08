Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbZDHJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbZDHJuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763528AbZDHJuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:50:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbZDHJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:50:12 -0400
To: Alex Chiang <achiang@hp.com>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
From: Andi Kleen <andi@firstfloor.org>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	<20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com>
Date: Wed, 08 Apr 2009 11:50:08 +0200
In-Reply-To: <20090408054612.GA6744@ldl.fc.hp.com> (Alex Chiang's message of "Tue, 7 Apr 2009 23:46:12 -0600")
Message-ID: <87myara2zz.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang <achiang@hp.com> writes:

> * Robin Holt <holt@sgi.com>:
>> Don't know if this answers your problem, but I use the tools from
>> emdebian and they do not suffer from the problems you list below.
>
> Wow, this seems _much_ simpler. Once you get the toolchain
> installed, all you have to do is set ARCH and CROSS_COMPILE
> appropriately?
>
> I guess the question remains for Andrew. Since I pretty much did
> all the work needed to update his cross-compiler repo, is there
> still value in it?
>
> Or shall we just recommend emdebian to everyone? :)

SUSE also has cross-gcc-* rpms. Typically for icecream, but they're
relatively easy to extract into native format.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
