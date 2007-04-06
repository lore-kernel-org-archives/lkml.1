Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXDFKlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXDFKlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXDFKlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:41:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:42652 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752474AbXDFKlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:41:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1nYVby3u16Q/qlg/DMZ88hfsuqO0xPyGjOjjdzR
	DzkB6MvKfvFrDU
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <20070406100333.GA19855@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704061103.34489.kernel@kolivas.org>
	 <1175850471.22272.8.camel@Homer.simpson.net>
	 <200704061928.39155.kernel@kolivas.org>  <20070406100333.GA19855@elte.hu>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 12:40:58 +0200
Message-Id: <1175856058.7546.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 12:03 +0200, Ingo Molnar wrote:

> already-fixed corners, but it didnt happen in practice. But ... i'm 
> awaiting further SD and Mike tweaks, the race certainly looks 
> interesting ;)

<g> I think I lapped him, but since we're running in opposite
directions, it's hard to tell.

	-Mike

