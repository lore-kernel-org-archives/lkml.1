Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZHZUuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZHZUuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZHZUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:50:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36117 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZHZUuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:50:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Hill <hilld@binarystorm.net>
Subject: Re: [Bug #13219] Intel 440GX: Since kernel 2.6.30-rc1, computers hangs randomly but not with kernel <= 2.6.29.6
Date: Wed, 26 Aug 2009 22:50:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera> <Cg6cQYLdUxG.A.lOD.82GlKB@chimera> <CA50EE78-9582-4F7B-84EA-40CACBDC5D0E@binarystorm.net>
In-Reply-To: <CA50EE78-9582-4F7B-84EA-40CACBDC5D0E@binarystorm.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262250.53429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, David Hill wrote:
> It seems to be fixed in 2.6.31-rc7

Thanks, bug closed.

Rafael


> On 2009-08-25, at 17:05, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still  
> > should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13219
> > Subject        : Intel 440GX: Since kernel 2.6.30-rc1, computers  
> > hangs randomly but not with kernel <= 2.6.29.6
> > Submitter    : David Hill <hilld@binarystorm.net>
> > Date        : 2009-05-01 16:57 (117 days old)
