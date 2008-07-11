Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYGKTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYGKTUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759275AbYGKTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399AbYGKTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:36 -0400
Date: Fri, 11 Jul 2008 12:18:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH 03/04] resource: use new resource type changes
Message-Id: <20080711121801.03fad25d.akpm@linux-foundation.org>
In-Reply-To: <1215605473.13186.2.camel@weaponx>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
	<20080709115452.14144.28953.sendpatchset@rx1.opensource.se>
	<1215605473.13186.2.camel@weaponx>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 08:11:13 -0400 Josh Boyer <jwboyer@gmail.com> wrote:

> >  arch/ppc/kernel/pci.c                      |   48 +++++++++++++---------------
> >  arch/ppc/syslib/ppc405_pci.c               |    2 -
> >  arch/ppc/syslib/ppc_sys.c                  |    2 -
> 
> You can drop the arch/ppc bits entirely.  arch/ppc won't exist in 2.6.27

yeah, I just applied the patch and ignored all the splatter.  Hopefully it
still works.

(linux-next -> thatta way, guys)
