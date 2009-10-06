Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZJFKHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZJFKHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZJFKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:07:13 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:59275 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277AbZJFKHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:07:12 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Date: Tue, 6 Oct 2009 11:06:33 +0100
User-Agent: KMail/1.9.10
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200910061106.33718.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/10/2009 11:06:34,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/10/2009 11:06:34,
	Serialize complete at 06/10/2009 11:06:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009 01:30:51 Linus Torvalds wrote:
> On Tue, 6 Oct 2009, Jeff Chua wrote:
> > Loud and clear. And appreciated all the replies. I think it's time for
> > upgrade!
>
> As Byron said, it really should be sufficient to just upgrade the kernel
> (I presume that you already have a CPU that is 64-bit capable: not very
> many boards with old CPU's can even fit 64GB of ram).
>
> In fact, I wish more people did that, just so that we'd get better
> coverage of the 32-bit compat code. We occasionally find issues there,
> although I think it's getting rarer.

Maybe convince some distro to offer this setup as an option at least? I always 
wondered why no one has, or maybe I missed it.

Tvrtko

