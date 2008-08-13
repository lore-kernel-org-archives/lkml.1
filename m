Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYHMGr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYHMGr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYHMGrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:47:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbYHMGru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:47:50 -0400
Date: Tue, 12 Aug 2008 23:47:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/22] x86: use the new byteorder headers
Message-Id: <20080812234703.4a9adbea.akpm@linux-foundation.org>
In-Reply-To: <1218607635.30194.115.camel@brick>
References: <1218587234.30194.93.camel@brick>
	<20080812225612.6742aaf0.akpm@linux-foundation.org>
	<20080812230205.680644a4.akpm@linux-foundation.org>
	<1218607635.30194.115.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 23:07:15 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Tue, 2008-08-12 at 23:02 -0700, Andrew Morton wrote:
> > On Tue, 12 Aug 2008 22:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > I'll drop them all.
> > 
> > btw, I had to rework several of these patches because everyone is
> > moving include/asm-arch/* into arch/include/asm/.  Patches against
> > linux-next would be preferred please.
> > 
> 
> Which arches? These were all against linux-next20080811.
> 

The ones which got changed in the past 24 hours I guess ;)

avr32 and xtensa, I think.

Ah, yes, I seem to have picked some trees which aren't in linux-next
for whatever reason.  See mmotm's git-parisc.patch and git-xtensa.patch.

