Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZJLPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZJLPhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZJLPhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:37:12 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:64088 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737AbZJLPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:37:11 -0400
Date: Mon, 12 Oct 2009 08:34:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [patch] perf build questions
Message-Id: <20091012083433.7b4d951b.randy.dunlap@oracle.com>
In-Reply-To: <20091012084734.GA18098@elte.hu>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
	<1254818939.21044.120.camel@laptop>
	<20091006102626.8b4f7810.randy.dunlap@oracle.com>
	<20091006180551.GB11702@bombadil.infradead.org>
	<20091006110941.eebe58af.randy.dunlap@oracle.com>
	<20091012084734.GA18098@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AD34CD0.012F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 10:47:34 +0200 Ingo Molnar wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > All 64-bit userspace & kernel.  so that fails.  Thanks.
> 
> btw., i'm curious, what was/is your motivation for cross-building in 
> that way? On a 64-bit system you really want a 64-bit perf binary - it's 
> faster.

I'm just trying to build 64-bit and 32-bit RPMs.

Thanks.
---
~Randy
