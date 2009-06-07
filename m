Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZFGU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZFGU7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZFGU7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:59:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59778 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbZFGU7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:59:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [Bug #13294] i915: drm: xorg leaks drm objects massively
Date: Sun, 7 Jun 2009 23:00:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.obB.3j7KKB@chimera> <20090607165018.4c946a30@mosly.slynet.org>
In-Reply-To: <20090607165018.4c946a30@mosly.slynet.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906072300.17220.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009, Sergei Trofimovich wrote:
> On Sun,  7 Jun 2009 12:06:23 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13294
> > Subject		: i915: drm: xorg leaks drm objects massively
> > Submitter	: Sergei Trofimovich <slyich@gmail.com>
> > Date		: 2009-05-10 19:56 (29 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124198547027903&w=4
> > 
> > 
> Rafael, please remove it from regression list. I haven't found kernel working
> the other way. It's a bug(set of bugs) being around "forever". Many people
> confirm it on various laptops/kernel versions. It's just not very noticeable.

OK, dropped.

Thanks,
Rafael
