Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbYDVVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbYDVVCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbYDVVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:02:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59859 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763105AbYDVVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:02:35 -0400
Message-ID: <5739699.1208898133855.JavaMail.oracle@acsmt302.oracle.com>
Date: Tue, 22 Apr 2008 16:02:13 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kgdb: core
Cc: jason.wessel@windriver.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080422135716.c6ee339b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
	<20080418150930.476ea7aa.akpm@linux-foundation.org>
	<20080421141252.GR9554@elte.hu>
	<20080421214636.617970c6.akpm@linux-foundation.org>
	<20080422082519.62adc7f1.randy.dunlap@oracle.com> <20080422135716.c6ee339b.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Original Message --- (akpm wrote:)
> > On Tue, 22 Apr 2008 08:25:19 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > kernel-doc output doesn't depend on build $ARCH.
> 
> Ah, interesting.  I made an ass of u and me.
> 
> In that case documentng them in x86 .c and leaving all other definitions
> and declarations uncommented sounds the way to go?  

Yes, that would be fine and traditional (historical).

~Randy

