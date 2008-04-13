Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYDMPQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYDMPQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYDMPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:16:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59678 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYDMPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:16:09 -0400
Date: Sun, 13 Apr 2008 10:13:04 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: monstr@seznam.cz
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, benh@kernel.crashing.org,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: Microblaze Linux release
Message-ID: <20080413101304.308f6c1a@zod.rchland.ibm.com>
In-Reply-To: <48020A21.4000404@seznam.cz>
References: <48020A21.4000404@seznam.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 15:26:57 +0200
Michal Simek <monstr@seznam.cz> wrote:

> Hi Everybody,
> 
> I fixed all reported bugs which I got from LKML and from you.
> Latest version of Microblaze Linux kernel is available at git.monstr.eu.
> There is git repository called linux-microblaze.git
> Microblaze port is based on 2.6.24-rc5. I'll create the new repo with clean pack
> of changes based on latest kernel version for easier pull.
> 
> Merge windows will be open hopefully next week and I would like to send pull
> request to Paul.

Why Paul?  If microblaze is a new architecture (which it seems to be),
then you should really work through Linus directly.

Also, which version of gcc/binutils are needed to actually build this?

josh
