Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYG3HTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYG3HTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYG3HTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:19:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbYG3HTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:19:33 -0400
Date: Wed, 30 Jul 2008 00:18:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 4/5] docsrc: fix crc32hash type
Message-Id: <20080730001850.c24fc671.akpm@linux-foundation.org>
In-Reply-To: <20080730064720.GA13409@isilmar.linta.de>
References: <12173619152424@xenotime.net>
	<1217361915584@xenotime.net>
	<20080730064720.GA13409@isilmar.linta.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 08:47:20 +0200 Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi,
> 
> On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix differing signedness warning:
> > 
> > Documentation/pcmcia/crc32hash.c:29: warning: pointer targets in passing argument 1 of 'crc32' differ in signedness
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> Shall this go in via the pcmcia git tree, or with the other doc patches?
> 

I was planning on merging them up in a week or so, if they don't appear
in anyone else's tree.

