Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXBJQdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXBJQdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXBJQdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:33:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXBJQdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:33:19 -0500
To: Christopher Li <sparse@chrisli.org>
Cc: linux-sparse@vger.kernel.org,
       linux kernel mail list <linux-kernel@vger.kernel.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: [ANNOUNCE] sparse-0.2-cl2 is now available
References: <20070204085329.GA6520@chrisli.org>
	<20070210000055.GA19968@chrisli.org>
From: Andi Kleen <ak@suse.de>
Date: 10 Feb 2007 18:33:25 +0100
In-Reply-To: <20070210000055.GA19968@chrisli.org>
Message-ID: <p73hctthq8q.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Li <sparse@chrisli.org> writes:
> 
> Change log in sparse-0.2-cl2:
>  - adding pointer signedness fix
>  - adding spinlock checking


Interesting. Did you find any kernel bugs with this?

-Andi
