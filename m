Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZGHGkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZGHGkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZGHGkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:40:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3071 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZGHGkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:40:03 -0400
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
From: Joe Perches <joe@perches.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
References: <cover.1247032324.git.joe@perches.com>
	 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
	 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 23:39:57 -0700
Message-Id: <1247035197.5124.9.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 09:32 +0300, Pekka Enberg wrote:
> Hi Joe,

Hi Pekka.

> On Wed, Jul 8, 2009 at 8:55 AM, Joe Perches<joe@perches.com> wrote:
> > from sections that should not have them.
> What is that supposed to mean?

That there should be no sections that have LKML as a
list entry other than "everything".

A earlier commit, b5472cddbe2c41fd434592ecf3c5b81a551d5bea,
removed all the entries for LKML but "THE REST".
These removed entries have been added since that commit.

Having just a few sections show LKML as an entry
may lead people to think that LKML should not be
used as a CC entry unless it is specifically listed.

Documentation/SubmittingPatches already states that
LKML should be CC'd on all patches.

cheers, Joe

