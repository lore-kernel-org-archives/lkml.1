Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZE0I5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZE0I5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760678AbZE0I5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:57:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:43804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbZE0I5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:57:07 -0400
Subject: Re: [Patch 2/2] Doc: move Documentation/exception.txt into x86
 subdir
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rdunlap@xenotime.net, mingo@elte.hu
In-Reply-To: <4A1CFBCB.8020808@redhat.com>
References: <20090527072952.6279.72977.sendpatchset@localhost.localdomain>
	 <20090527073001.6279.90725.sendpatchset@localhost.localdomain>
	 <1243412698.3109.4.camel@localhost.localdomain>
	 <4A1CFBCB.8020808@redhat.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 14:26:34 +0530
Message-Id: <1243414594.3109.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 16:37 +0800, Amerigo Wang wrote:
> Jaswinder Singh Rajput wrote:
> > On Wed, 2009-05-27 at 03:28 -0400, Amerigo Wang wrote:
> >   
> >> exception.txt only explains the code on x86, so it's better to
> >> move it into Documentation/x86 directory.
> >>
> >> This patch is on top of the previous one.
> >>
> >> Signed-off-by: WANG Cong <amwang@redhat.com>
> >> Cc: Randy Dunlap <rdunlap@xenotime.net>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >>
> >> ---
> >> Index: linux-2.6/Documentation/exception.txt
> >> ===================================================================
> >> --- linux-2.6.orig/Documentation/exception.txt
> >> +++ /dev/null
> >>     
> >
> >   
> >> Index: linux-2.6/Documentation/x86/extable.txt
> >> ===================================================================
> >> --- /dev/null
> >> +++ linux-2.6/Documentation/x86/extable.txt
> >>     
> >
> > What is the reason of this name change exception.txt -> extable.txt
> >   
> Hello,
> 
> Because this doc explains how exception tables work on x86, not the 
> hardware concept
> "exceptions" of x86 CPU, thus extable.txt is much more reasonable. :)
> 

In such case you can use exception-tables.txt or
exception-tables-howto.txt

--
JSR

