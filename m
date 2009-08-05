Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbZHEGNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbZHEGNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbZHEGNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:13:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbZHEGNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:13:54 -0400
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: npiggin@suse.de, riel@redhat.com, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [12/15] HWPOISON: The high level memory error handler in the VM v7
From: Andi Kleen <andi@firstfloor.org>
References: <200908041152.240876191@firstfloor.org>
	<20090804215311.5D5A0B15D8@basil.firstfloor.org>
	<4A791AF6.3040902@hitachi.com>
Date: Wed, 05 Aug 2009 08:13:50 +0200
In-Reply-To: <4A791AF6.3040902@hitachi.com> (Hidehiro Kawai's message of "Wed, 05 Aug 2009 14:39:02 +0900")
Message-ID: <878whykctd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> writes:
>
> I couldn't find the definition of error_remove_page in
> address_space_operations.  Didn't you miss sending a patch?

Yes indeed I did, the patch submission list was outdated
and also contained another bogus patch.

Sorry about that. I'll resend.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
