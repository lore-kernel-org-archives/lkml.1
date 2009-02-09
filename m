Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZBIAkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZBIAkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZBIAk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:40:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZBIAk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:40:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12503] [slab corruption] BUG key_jar: Poison overwritten
Date: Mon, 9 Feb 2009 01:40:15 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.z2G.h30jJB@chimera> <20090208221231.GA9160@elte.hu>
In-Reply-To: <20090208221231.GA9160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902090140.16694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12503
> > Subject		: [slab corruption] BUG key_jar: Poison overwritten
> > Submitter	: Ingo Molnar <mingo@elte.hu>
> > Date		: 2009-01-15 18:16 (25 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123204353425825&w=4
> > Handled-By	: David Howells <dhowells@redhat.com>
> 
> This slab corruption has not triggered again. It's either a very rare thing (in 
> which case there's no realistic way to debug it via this angle), or it got fixed 
> meanwhile.
> 
> Please close it. Thanks,

Closed as "unreproducible".

Thanks,
Rafael
