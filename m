Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbYGOUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbYGOUSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYGOUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:18:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYGOUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:18:46 -0400
Date: Tue, 15 Jul 2008 13:18:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: pageexec@freemail.hu
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D20EC.26203.1BD1E5C5@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.10.0807151317270.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D10B3.5586.1B9284FF@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151211180.3351@woody.linux-foundation.org> <487D20EC.26203.1BD1E5C5@pageexec.freemail.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, pageexec@freemail.hu wrote:
>
> in any case, i don't see why you can't put keywords into the commit
> that say the bug being fixed is 'security related' or 'potentially 
> exploitable', etc. people can then decide how to prioritize them.

Because I see no point. Quite often, we don't even realize some random bug 
could have been a security issue.

It's not worth my energy, in other words. 

			Linus
