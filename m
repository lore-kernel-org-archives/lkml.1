Return-Path: <linux-kernel-owner+w=401wt.eu-S1422670AbXBAIfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670AbXBAIfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422679AbXBAIfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:35:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422670AbXBAIfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:35:30 -0500
Date: Thu, 1 Feb 2007 00:34:50 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New module-init-tools pre-release (v3.3-pre6)
Message-Id: <20070201003450.f0164d3e.akpm@osdl.org>
In-Reply-To: <20070201081036.GC32510@dallas.jonmasters.org>
References: <45C188AB.1060207@jonmasters.org>
	<20070131231731.4b88d8f6.akpm@osdl.org>
	<20070201081036.GC32510@dallas.jonmasters.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 08:10:36 +0000 Jon Masters <jonathan@jonmasters.org> wrote:

> On Wed, Jan 31, 2007 at 11:17:31PM -0800, Andrew Morton wrote:
> > On Thu, 01 Feb 2007 01:28:59 -0500 Jon Masters <jonathan@jonmasters.org> wrote:
> > > I took over upstream maintainership of the module-init-tools package 
> > > from Rusty at the end of last year.
> 
> > Cool.  A patch to the kernel's ./MAINTAINERS would be appreciated.
> 
> Sent a patch against the MODULE SUPPORT entry in MAINTAINERS since I
> guess that's the existing entry you're refering to.
> 

No, I was thinking of a record which explicitly mentions module-init-tools.
It's not a part of the kernel, but it is closely connected to it, and this is
useful information to have in ./MAINTAINERS.

The patch you sent claims that you maintain kernel/module.c.
