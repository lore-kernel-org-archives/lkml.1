Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZBUQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZBUQ0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbZBUQ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:26:08 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58413 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZBUQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:26:05 -0500
Message-ID: <49A02A23.8000308@cs.helsinki.fi>
Date: Sat, 21 Feb 2009 18:21:55 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: rip out REP instruction emulation
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com> <1235223364-2097-3-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1235223364-2097-3-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> As it turns out, disabling the "fast strings" of the P4 fixed the
> REP single-stepping issue, so this code is not needed anymore.
> 
> Celebrate, for we just got rid of a LOT of complexity and pain.
> 
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
