Return-Path: <linux-kernel-owner+w=401wt.eu-S934733AbYBTVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbYBTVpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934355AbYBTVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:44:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45023 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417AbYBTVoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:44:54 -0500
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080220130736.4ccb2687@laptopd505.fenrus.org>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
	 <1203531375.6243.52.camel@lappy>
	 <20080220103940.0a0b5ce0@laptopd505.fenrus.org>
	 <1203533622.6243.55.camel@lappy>
	 <20080220112655.18011dab@laptopd505.fenrus.org>
	 <1203541122.6243.103.camel@lappy>
	 <20080220130736.4ccb2687@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:44:29 +0100
Message-Id: <1203543869.6243.106.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 13:07 -0800, Arjan van de Ven wrote:
> On Wed, 20 Feb 2008 21:58:42 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > On Wed, 2008-02-20 at 11:26 -0800, Arjan van de Ven wrote:
> > 
> > > feel free to reinvent a whole GUI just to avoid a 200 line kernel
> > > module. sysprof is here. it works. 
> > 
> > > the gui is REALLY nice.
> > 
> > I guess we have to agree to disagree here. Its plain useless from my
> > POV.
> 
> that's fine. Different tools for different people. sysprof isn't aimed
> at kernel developers.

That was speaking from userland days.

But you forgot the more important points about API and wild-growth of
duplicate interfaces.

