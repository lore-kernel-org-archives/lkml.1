Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbZFMMYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbZFMMYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZFMMYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:24:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39712 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZFMMYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:24:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Date: Sat, 13 Jun 2009 13:23:00 +0100
Message-ID: <24680.1244895780@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> From: Jie Zhang <jie.zhang@analog.com>
> 
> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Bernd Schmidt <bernds_cb1@t-online.de>

Acked-by: David Howells <dhowells@redhat.com>
