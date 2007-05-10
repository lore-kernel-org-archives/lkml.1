Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbXEJPpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbXEJPpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXEJPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:45:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19251 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXEJPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:45:40 -0400
Date: Thu, 10 May 2007 08:48:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 -- powerpc missing kset
Message-Id: <20070510084802.04476f66.randy.dunlap@oracle.com>
In-Reply-To: <20070510221631.5eb38bdd.sfr@canb.auug.org.au>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<4643068C.8010302@shadowen.org>
	<20070510221631.5eb38bdd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 22:16:31 +1000 Stephen Rothwell wrote:

> On Thu, 10 May 2007 12:48:28 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> >
> > arch/powerpc/platforms/pseries/power.c:31: warning: `struct subsystem'
> > declared inside parameter list
> 
> There is no explicit reference to struct subsystem in the current version
> of that file.

There is in 2.6.21-mm2.  Are you saying that it's been fixed
somewhere else?  (where?)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
