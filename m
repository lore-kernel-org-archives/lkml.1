Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZKFKU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZKFKU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 05:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZKFKU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 05:20:58 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55417 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbZKFKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 05:20:57 -0500
From: Frans Pop <elendil@planet.nl>
To: nir.tzachar@gmail.com
Subject: Re: [PATCH] nconfig v5
Date: Fri, 6 Nov 2009 11:20:59 +0100
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       nir.tzachar@gmail.com, sam@ravnborg.org, zippel@linux-m68k.org,
       andi@firstfloor.org
References: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
In-reply-To: <1257496614-12052-1-git-send-email-nir.tzachar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911061121.01725.elendil@planet.nl>
X-OriginalArrivalTime: 06 Nov 2009 10:21:01.0833 (UTC) FILETIME=[D7147F90:01CA5ECA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

nir.tzachar@gmail.com wrote:
> scripts/kconfig/nconf.c     | 1545 +++++++++++++++++++++++++++++++++++++++++++
> scripts/kconfig/nconf.gui.c |  613 +++++++++++++++++ 
> scripts/kconfig/nconf.h     |   93 +++ 
> 3 files changed, 2251 insertions(+), 0 deletions(-)
> create mode 100644 scripts/kconfig/nconf.c
> create mode 100644 scripts/kconfig/nconf.gui.c
> create mode 100644 scripts/kconfig/nconf.h

Thought I'd give this a try, but compared with V4 this patch looks incomplete.
It's missing e.g. the Makefile changes.

Cheers,
FJP
