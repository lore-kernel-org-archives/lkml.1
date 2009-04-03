Return-Path: <linux-kernel-owner+w=401wt.eu-S932599AbZDCP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbZDCP3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZDCP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:29:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40253 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbZDCP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:29:10 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LANANA: Change of management and resync
From: Andi Kleen <andi@firstfloor.org>
References: <20090403135051.19177.23019.stgit@localhost.localdomain>
Date: Fri, 03 Apr 2009 17:29:02 +0200
In-Reply-To: <20090403135051.19177.23019.stgit@localhost.localdomain> (Alan Cox's message of "Fri, 03 Apr 2009 14:50:52 +0100")
Message-ID: <874ox5lps1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> @@ -340,7 +345,7 @@ Your cooperation is appreciated.
>  		 14 = /dev/touchscreen/ucb1x00  UCB 1x00 touchscreen
>  		 15 = /dev/touchscreen/mk712	MK712 touchscreen
>  		128 = /dev/beep		Fancy beep device
> -		129 = /dev/modreq	Kernel module load request {2.6}
> +		129 = 

You drop a lot of entries like this. Was that intended?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
