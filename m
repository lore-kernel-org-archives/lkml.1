Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZKWCIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZKWCIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZKWCIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:08:12 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:62384 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbZKWCIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:08:11 -0500
Date: Sun, 22 Nov 2009 18:06:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel.h: Fix kernel-doc notation
Message-Id: <20091122180635.93f06566.randy.dunlap@oracle.com>
In-Reply-To: <200911231220.26402.rusty@rustcorp.com.au>
References: <1258877529.4495.43.camel@ht.satnam>
	<200911231220.26402.rusty@rustcorp.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B09EE58.017D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 12:20:26 +1030 Rusty Russell wrote:

> On Sun, 22 Nov 2009 06:42:09 pm Jaswinder Singh Rajput wrote:
> > 
> > Fix the following htmldocs warnings:
> > 
> >   Warning(include/linux/kernel.h:708): No description found for parameter 'condition'
> >   Warning(include/linux/kernel.h:708): Excess function parameter 'cond' description in 'BUILD_BUG_ON'
> 
> This look like  ajob for trivial@kernel.org or akpm?

Yes, normally each subsystem maintainer or trivial should do this.

> For the pedants: Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Thanks!
> Rusty.

Thanks.
---
~Randy
