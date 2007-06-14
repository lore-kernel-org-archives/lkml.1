Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbXFNUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbXFNUH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXFNUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:07:49 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:60759 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbXFNUHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:07:48 -0400
Date: Thu, 14 Jun 2007 22:07:47 +0200
From: DervishD <lkml@dervishd.net>
To: Jan Knutar <jk-lkml@sci.fi>
Cc: linux-kernel@vger.kernel.org, Juergen Beisert <juergen127@kreuzholzen.de>
Subject: Re: ext2 on flash memory
Message-ID: <20070614200747.GB1928@DervishD>
Mail-Followup-To: Jan Knutar <jk-lkml@sci.fi>,
	linux-kernel@vger.kernel.org,
	Juergen Beisert <juergen127@kreuzholzen.de>
References: <20070611101319.GA14284@DervishD> <200706112127.42119.juergen127@kreuzholzen.de> <20070613134843.GC1983@DervishD> <200706142236.56195.jk-lkml@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706142236.56195.jk-lkml@sci.fi>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan Knutar <jk-lkml@sci.fi> dixit:
> On Wednesday 13 June 2007 16:48, DervishD wrote:
> > But anyway the memory should last long. Even cheap flash memories
> > with poor wear leveling (if any at all) usually long last. Given
> > that I won't be writing continuously, wear shouldn't be a problem.
> > I'm going to use this as a backup copy of my home. Of course, I can
> > use a tarball too...
> 
> I did a test on my kingston datatraveler recently, I didn't expect it
> to survive, but it did.

    Aaaaagh! Never do such tests again, or at least don't tell me XD

> Considering it surived ReiserFS, I suspect it would last ages with
> ext2, especially for your backup purposes.

    I don't really know the number of writes that a flash memory allows
nowadays, but probably they're 10000 even in cheap ones, and with proper
wear leveling that should mean a looooot of time.

    Thanks for the test, really O:))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
