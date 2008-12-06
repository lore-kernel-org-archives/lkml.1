Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYLFIz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYLFIz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 03:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYLFIzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 03:55:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53143 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYLFIzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 03:55:47 -0500
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is vm86old no more implemented?
From: Andi Kleen <andi@firstfloor.org>
References: <200812061043.51438.arvidjaar@mail.ru>
Date: Sat, 06 Dec 2008 09:56:03 +0100
In-Reply-To: <200812061043.51438.arvidjaar@mail.ru> (Andrey Borzenkov's message of "Sat, 6 Dec 2008 10:43:50 +0300")
Message-ID: <87y6ytvg0s.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov <arvidjaar@mail.ru> writes:
>
> CONFIG_VM86 is defined; is there anything else that is needed? This fails 
> both in 2.6.27.7 and in 2.6.28-rc7. I attach config from 2.6.28-rc7.

It should still work. Can you double check you're running the correct kernel?
Perhaps a 64bit kernel (which doesn't implement it).

-Andi

-- 
ak@linux.intel.com
