Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZHZUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZHZUyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZHZUyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:54:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZHZUyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:54:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [Bug #14059] DomU crashes during xenfb initialization
Date: Wed, 26 Aug 2009 22:55:14 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <Cg6cQYLdUxG.A.XNB.5zGlKB@chimera> <20090826161805.2697d932@leela>
In-Reply-To: <20090826161805.2697d932@leela>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262255.14947.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Michal Schmidt wrote:
> Dne Tue, 25 Aug 2009 23:05:07 +0200 (CEST) Rafael J. Wysocki napsal:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still
> > should be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14059
> > Subject	: DomU crashes during xenfb initialization
> > Submitter	: Michal Schmidt <mschmidt@redhat.com>
> > Date		: 2009-08-21 10:40 (5 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=125085108431360&w=4
> > Handled-By	: Michal Schmidt <mschmidt@redhat.com>
> > Patch		: http://patchwork.kernel.org/patch/43107/
> 
> The patch is not in mainline yet, it's only in Jeremy's git tree.

Yes, that's why the bug hasn't been closed yet.

Rafael
