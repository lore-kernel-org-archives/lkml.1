Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZGHGov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZGHGov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZGHGon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:44:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33331 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZGHGon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:44:43 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <1247035197.5124.9.camel@Joe-Laptop.home>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
	 <1247035197.5124.9.camel@Joe-Laptop.home>
Date: Wed, 08 Jul 2009 09:44:41 +0300
Message-Id: <1247035481.15919.31.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 2009-07-07 at 23:39 -0700, Joe Perches wrote:
> > On Wed, Jul 8, 2009 at 8:55 AM, Joe Perches<joe@perches.com> wrote:
> > > from sections that should not have them.
> > What is that supposed to mean?
> 
> That there should be no sections that have LKML as a
> list entry other than "everything".
> 
> A earlier commit, b5472cddbe2c41fd434592ecf3c5b81a551d5bea,
> removed all the entries for LKML but "THE REST".
> These removed entries have been added since that commit.

OK, I don't agree, but as Andrew apparently thinks it's a good idea
because he merged the previous patch, there's no reason not to merge the
new one.

On Tue, 2009-07-07 at 23:39 -0700, Joe Perches wrote:
> Documentation/SubmittingPatches already states that
> LKML should be CC'd on all patches.

Maybe it does, but real world doesn't seem to agree with you here.

			Pekka

