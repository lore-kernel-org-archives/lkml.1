Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZBEVUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZBEVUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZBEVUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:20:40 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45365 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZBEVUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:20:39 -0500
Date: Thu, 5 Feb 2009 21:20:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <1233867944.4612.104.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0902052113270.23510@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>  <pWZw1SZjMCH.A.sIE.wuYiJB@chimera>
 <1233791329.4612.23.camel@pasglop>  <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
 <1233867944.4612.104.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> It should be a trivial fix on X side tho.

It will be unusual to require users of a new kernel to install a new X.

Hugh
