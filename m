Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbYDVU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbYDVU7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYDVU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:59:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365AbYDVU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:59:09 -0400
Date: Tue, 22 Apr 2008 13:57:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mingo@elte.hu, jason.wessel@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: kgdb: core
Message-Id: <20080422135716.c6ee339b.akpm@linux-foundation.org>
In-Reply-To: <20080422082519.62adc7f1.randy.dunlap@oracle.com>
References: <200804181741.m3IHfTeC012089@hera.kernel.org>
	<20080418150930.476ea7aa.akpm@linux-foundation.org>
	<20080421141252.GR9554@elte.hu>
	<20080421214636.617970c6.akpm@linux-foundation.org>
	<20080422082519.62adc7f1.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Apr 2008 08:25:19 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> kernel-doc output doesn't depend on build $ARCH.

Ah, interesting.  I made an ass of u and me.

In that case documentng them in x86 .c and leaving all other definitions
and declarations uncommented sounds the way to go?  
