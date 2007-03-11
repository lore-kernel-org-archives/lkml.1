Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXCKVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXCKVSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXCKVSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:18:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:49581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932382AbXCKVS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:18:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19DL31C6dFDW84WUpJOGWeYYZQkq3htGiOux5Jhcw
	9JQF2jGitnC+eh
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1173615642.6927.38.camel@Homer.simpson.net>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173613149.6927.29.camel@Homer.simpson.net>
	 <20070311121038.GA9146@elte.hu>
	 <1173615642.6927.38.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 22:18:18 +0100
Message-Id: <1173647898.6414.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 13:20 +0100, Mike Galbraith wrote:

> I'll boot up nosmp and report back

Hohum.  nosmp doesn't boot (locks after ide [bla] IRQ 14), will
recompile UP in the A.M. and try again.

