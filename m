Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZBEBNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZBEBNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZBEBNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:13:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbZBEBNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:13:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Bug #12511] WARNING: at drivers/dma/dmaengine.c:352
Date: Thu, 5 Feb 2009 02:13:12 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.dvF.SvYiJB@chimera> <e9c3a7c20902040803p12ffe0bcrced5249c4b667623@mail.gmail.com>
In-Reply-To: <e9c3a7c20902040803p12ffe0bcrced5249c4b667623@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050213.13869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Dan Williams wrote:
> On Wed, Feb 4, 2009 at 3:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> >
> 
> This should be resolved as of commit 83436a05 "dmaengine: kill some
> dubious WARN_ONCEs"

Thanks, closed.

Rafael
