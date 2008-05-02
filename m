Return-Path: <linux-kernel-owner+w=401wt.eu-S935384AbYEBPnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384AbYEBPnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764457AbYEBPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:42:55 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:44207 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764438AbYEBPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:42:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] hfsplus: Correct user visible printk
Date: Fri, 2 May 2008 17:42:49 +0200
User-Agent: KMail/1.9.9
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20080502142925.2e439d8a@core> <200805021600.42610.elendil@planet.nl> <20080502150439.76beaf27@core>
In-Reply-To: <20080502150439.76beaf27@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021742.50509.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 15:42:51.0165 (UTC) FILETIME=[2DE6FCD0:01C8AC6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Alan Cox wrote:
> > BTW, what is common spelling in the kernel British or American English?
>
> It varies. The fs journal code uses both at random sometimes mixed in the
> same paragraph. Fortunately "to journalise" is valid in both US and UK
> English.

Well, my spellchecker rejects the -se but recognizes the -ze. It also has no 
problems with journaled.

> > journaled:     134,000 hits ( 8.7% of above total)
>
> Almost entirely caused by Linux.

Sure. But that only proves my point: once something has been accepted as 
common language and a term, however technically wrong, is recognized to 
stand for something by the majority of existing users, it is probably wrong 
to change it. After all, language is a living and evolving thing. This is 
exactly how new words, terms and simplifications are introduced.

Google clearly shows that journaled is the accepted, and thus preferred 
term. Maybe if you'd proposed this patch (and others everywhere else 
journaled has been used) 5 years ago you'd been right. At this stage I 
think a change would only confuse.

Cheers,
FJP
