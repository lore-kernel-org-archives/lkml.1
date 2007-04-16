Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXDPWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXDPWmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXDPWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:42:39 -0400
Received: from gw.goop.org ([64.81.55.164]:47638 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXDPWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:42:39 -0400
Message-ID: <4623A03C.1030105@goop.org>
Date: Mon, 16 Apr 2007 11:11:40 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc6 + firstfloor patches: BUG: sleeping function called
 from invalid context at kernel/sched,.c:3643
References: <462072C2.4070605@goop.org> <200704141338.50058.ak@suse.de> <462143B9.6080907@goop.org> <200704151223.19599.ak@suse.de>
In-Reply-To: <200704151223.19599.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hmm, are you sure? Can you double check?  With the latest tree?
>
> I could reproduce the problem and my change fixed the problem for me.
>   

Hm.  Me too.  I just booted 2.6.21-rc7-ff-paravirt, and it seems fine.

    J

