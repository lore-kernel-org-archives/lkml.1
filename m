Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbXHTG2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbXHTG2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 02:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbXHTG2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 02:28:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXHTG2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 02:28:37 -0400
Date: Mon, 20 Aug 2007 14:28:16 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: h.verhagen.web104@dse.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at lib/list_debug.c:27!
Message-ID: <20070820062816.GA7089@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <f822aa1f0708191008p64bdd6fcj3e6bbf848b24e134@mail.gmail.com> <f822aa1f0708191350k45269563u1422fc45d4f03fac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f822aa1f0708191350k45269563u1422fc45d4f03fac@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

<quote sender="h.verhagen.web104@dse.nl">
> Hi,
> 
> According to dmesg, I encountered a kernel bug on my system.
> I'm not sure if this is the appropriate place to report this problem
> as this occured on a Fedora kernel. Maybe its a general problem?

Please file a bug at https://bugzilla.redhat.com/ under Product: Fedora,
Version: f7, and Component: kernel.

> kernel BUG at lib/list_debug.c:27!
> invalid opcode: 0000 [2] SMP

BZ#247975 looks similar, but I am not sure if it is the same issue.

Hope this helps.

Thanks,
Eugene
