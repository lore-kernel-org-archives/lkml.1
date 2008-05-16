Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYEPFiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYEPFiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYEPFhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:37:54 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:47141 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYEPFhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:37:53 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: spontaneous reboots and hangs on x86_64
Date: Fri, 16 May 2008 07:37:50 +0200
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200805152201.49154.m.kozlowski@tuxland.pl> <20080516140625.25fac6a2.sfr@canb.auug.org.au> <200805160717.31618.m.kozlowski@tuxland.pl>
In-Reply-To: <200805160717.31618.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805160737.50373.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > > ~/linux/linux-next $ git bisect start
> > > > fatal: ref HEAD is not a symbolic ref
> > > > Bad HEAD - I need a symbolic ref
> > 
> > This would indicate something wrong with your clone of linux-next.  How
> > did you create the repository?
> > 
> > > > - how does one bisect on linux-next?
> > 
> > Any day's linux-next tree is a git tree like any other ...
> 
> Hm it can be that I did something wrong ...

and I did :/ I think I just started this repo in wrong way - according to linux-next FAQ.
I'll just start from scratch then.

Thanks,

	Mariusz

