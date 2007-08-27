Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXH0I7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXH0I7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXH0I7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:59:12 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:48800 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752310AbXH0I7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:59:11 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2007 04:59:11 EDT
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <daenzer@debian.org>
To: =?ISO-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?ISO-8859-1?Q?Rog=E9rio?= Brito <rbrito@gmail.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20070827065246.GA21220@ime.usp.br>
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
	 <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>
	 <20070827065246.GA21220@ime.usp.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Debian
Date: Mon, 27 Aug 2007 10:37:27 +0200
Message-Id: <1188203847.10738.357.camel@thor.sulgenrain.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 03:52 -0300, Rogério Brito wrote:
> 
> I did 13 compiles with git bisect and some of them were unsucessfuly
> compiled, which I am afraid that may miss the real cause if I tag them as
> being "bad" (which I did).

Yes, don't mark such cases as bad or good but look for a nearby commit
that compiles.


-- 
Earthling Michel Dänzer           |          http://tungstengraphics.com
Libre software enthusiast         |          Debian, X and DRI developer
