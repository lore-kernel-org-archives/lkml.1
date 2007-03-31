Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXCaRBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXCaRBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 13:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXCaRBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 13:01:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50721 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXCaRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 13:01:16 -0400
Date: Sun, 1 Apr 2007 01:57:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: updated list of "dead" Makefile CONFIG_ variables
Message-ID: <20070331165758.GA19727@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703310552560.26371@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 06:12:01AM -0400, Robert P. J. Day wrote:
> ===== SH_KGDB =====
> ./arch/sh/kernel/Makefile:obj-$(CONFIG_SH_KGDB)         += kgdb_stub.o kgdb_jmp.o
> ./arch/sh/Makefile:cflags-$(CONFIG_SH_KGDB)             += -g

These are fixed in my 2.6.22 queue.
