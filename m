Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbXA2NxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbXA2NxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXA2NxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:53:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbXA2NxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:53:04 -0500
From: Andi Kleen <ak@suse.de>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: - romsignature-checksum-cleanup-2.patch removed from -mm tree
Date: Mon, 29 Jan 2007 14:52:43 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <200701102244.l0AMiWIA010198@shell0.pdx.osdl.net> <45BDFA9B.6020403@gmail.com>
In-Reply-To: <45BDFA9B.6020403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291452.43367.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 14:46, Rene Herman wrote:
> On 01/10/2007 11:44 PM, akpm@osdl.org wrote:
> 
> > The patch titled
> >      romsignature/checksum cleanup
> > has been removed from the -mm tree.  Its filename was
> >      romsignature-checksum-cleanup-2.patch
> > 
> > This patch was dropped because x86_64 tree changes trashed it
> 
> I was (am) quite unsure why this was, given that the patch did not touch 
> x86_64 at all and moreover continued to apply cleanly to mm...

The x86_64 tree is really a x86 tree these days and contains most i386 changes.

But in general if you change i386 then changing x86_64 makes sense too.

-Andi
