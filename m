Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbZD2Tso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbZD2Tso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760912AbZD2Try
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:47:54 -0400
Received: from verein.lst.de ([213.95.11.210]:46948 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738AbZD2Trx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:47:53 -0400
Date: Wed, 29 Apr 2009 21:44:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, chris@zankel.net, cooloney@kernel.org,
       deller@gmx.de, geert@linux-m68k.org, gerg@uclinux.org,
       hskinnemoen@atmel.com, jdike@addtoit.com, jesper.nilsson@axis.com,
       kyle@mcmartin.ca, linux@arm.linux.org.uk, ralf@linux-mips.org,
       rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org,
       ysato@users.sourceforge.jp, zippel@linux-m68k.org,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Fwd: arch/ && tracehook_report_syscall_xxx()
Message-ID: <20090429194412.GA3306@lst.de>
References: <20090427180455.GA32509@redhat.com> <20090427182919.B923DFC3BF@magilla.sf.frob.com> <20090427183218.GA31596@lst.de> <20090429190852.GA14515@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429190852.GA14515@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 09:08:52PM +0200, Oleg Nesterov wrote:
> . Could you please convert your syscall trace code to use
> tracehook_report_syscall_entry/tracehook_report_syscall_exit ?

This is part of Roland's step by step cookbook for new-style ptrace,
so we should have most done.  Is there anything that makes this more
urgent than the others steps for you?

