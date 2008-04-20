Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYDTAQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYDTAQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYDTAQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:16:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38152
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbYDTAQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:16:27 -0400
Date: Sat, 19 Apr 2008 17:16:28 -0700 (PDT)
Message-Id: <20080419.171628.191209639.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mtk.manpages@gmail.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
       maxk@qualcomm.com, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer
 interface.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804200241.14722.rusty@rustcorp.com.au>
References: <20080418115959.6b8fdfa7.akpm@linux-foundation.org>
	<517f3f820804181238s79326d10tf898691f997715e5@mail.gmail.com>
	<200804200241.14722.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 20 Apr 2008 02:41:14 +1000

> If only there were some kind of, I don't know... summit... for kernel 
> people... 

I'm starting to disbelieve the myth that because we can discuss
technical issues on mailing lists, we should talk primarily about
process issues during the kernel summit.

There is a distinct advantage to discussing and hashing things out in
person.  You can't say "screw you, your idea sucks" when you're face
to face with the other person, whereas online it's way too easy.
