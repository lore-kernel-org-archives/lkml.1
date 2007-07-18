Return-Path: <linux-kernel-owner+w=401wt.eu-S936268AbXGRS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936268AbXGRS52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbXGRS5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:57:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:43170 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078AbXGRS5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:57:17 -0400
X-IronPort-AV: E=Sophos;i="4.16,552,1175497200"; 
   d="scan'208";a="83465718"
Subject: Re: sunrpc-related Oops in latest git
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070718200756.761e2683@dhcp-255-175.norway.atmel.com>
References: <20070715170523.2bed7110@dhcp-255-175.norway.atmel.com>
	 <1184597534.11083.1.camel@heimdal.trondhjem.org>
	 <20070718200756.761e2683@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Network Appliance Inc
Date: Wed, 18 Jul 2007 14:57:11 -0400
Message-Id: <1184785031.6727.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Jul 2007 18:57:12.0681 (UTC) FILETIME=[73535D90:01C7C96D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 20:07 +0200, Haavard Skinnemoen wrote:
> On Mon, 16 Jul 2007 10:52:14 -0400
> Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > > Please let me know if there's anything I can do to help debug this.
> > > 
> > > Håvard  
> > 
> > So you are saying that if you revert this patch, and only this patch,
> > then it fixes nfsroot? (sorry, I tend not to trust git-bisect)
> 
> Well, what do you know. My atomics are broken.
> 
> The patch below fixes it. I'll include it in my next pull request,
> which I'll send in a moment. Sorry to bother you about this.
> 
> Håvard

That is good news. Thanks Håvard! :-)

Trond
