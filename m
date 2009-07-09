Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZGIRXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZGIRXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZGIRW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:22:56 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:41722 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZGIRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:22:55 -0400
Date: Thu, 9 Jul 2009 10:22:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 6-July 9 (percpu/x86)
Message-Id: <20090709102248.01e2312c.randy.dunlap@oracle.com>
In-Reply-To: <20090706095343.df21d4c9.rdunlap@xenotime.net>
References: <20090706162632.fdde002e.sfr@canb.auug.org.au>
	<20090706095343.df21d4c9.rdunlap@xenotime.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A562765.01E5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 09:53:43 -0700 Randy Dunlap wrote:

> On Mon, 6 Jul 2009 16:26:32 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20090703:
> > 
> > The percpu tree lost all its conflicts but gained another against the tip
> > tree.
> 
> arch/x86/mm/pageattr.c: In function 'cpa_process_alias':
> arch/x86/mm/pageattr.c:749: error: implicit declaration of function 'pcpu_lpage_remapped'
> 
> config attached.


Still present in 20090709...


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
