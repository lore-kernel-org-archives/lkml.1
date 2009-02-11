Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZBKOCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZBKOCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZBKOCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:02:11 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:44363 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZBKOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:02:10 -0500
Subject: Re: next-20090211: BUG: MAX_LOCKDEP_SUBCLASSES too low!
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1234360834.23438.162.camel@twins>
References: <a4423d670902110414r72f14c1eq850cda59533bd9db@mail.gmail.com>
	 <1234355010.23438.132.camel@twins> <1234355070.23438.133.camel@twins>
	 <1234355201.23438.134.camel@twins>
	 <a4423d670902110452s5fb6d041l2363c8ad9b9618fb@mail.gmail.com>
	 <1234357467.23438.151.camel@twins>  <1234360834.23438.162.camel@twins>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 09:01:36 -0500
Message-Id: <1234360896.8537.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.4992DA44.01FB:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 15:00 +0100, Peter Zijlstra wrote:

> > > > Could you run with the below patch, so that we can see where this
> > > > happens?
> > 
> > Tssk, Chris what you have been doing?
> 
> Would something like this work?
> 

It's almost perfect ;) I just need BTRFS_MAX_LEVEL, which is 8, will
test and merge up.  Thanks!

-chris


