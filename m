Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbYD3Wbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbYD3Wbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934385AbYD3Wba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:31:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763324AbYD3Wb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:31:29 -0400
Date: Wed, 30 Apr 2008 15:31:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805010023.32213.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> 
> > And there's no way to avoid the fact that during the merge window, we will 
> > get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
> > 9629 commits).
> 
> Well, do we _have_ _to_ take that much?  I know we _can_, but is this really
> necessary?

Do you want me to stop merging your code?

Do you think anybody else does?

Any suggestions on how to convince people that their code is not worth 
merging?

		Linus
