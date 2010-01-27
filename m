Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931Ab0A0VD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0A0VD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432Ab0A0VD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:03:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34339 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab0A0VD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:03:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #15129] [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
Date: Wed, 27 Jan 2010 22:03:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Miles Lane" <miles.lane@gmail.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.WQF.-JMXLB@chimera> <20100127095832.2d8c42b5@jbarnes-piketon>
In-Reply-To: <20100127095832.2d8c42b5@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001272203.59652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010, Jesse Barnes wrote:
> On Sun, 24 Jan 2010 23:04:39 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15129
> > Subject		: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
> > Submitter	: Miles Lane <miles.lane@gmail.com>
> > Date		: 2010-01-14 23:18 (11 days old)
> > References	: http://lkml.org/lkml/2010/1/14/570
> > Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> 
> I think this message has been rightly killed.  Getting -ERESTARTSYS from
> this function is perfectly normal, so we shouldn't bother printing a
> message about it.

OK, closing this one.

Rafael
