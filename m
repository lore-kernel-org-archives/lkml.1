Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZGGLN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZGGLN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZGGLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:13:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZGGLNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:13:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #13690] nodes_clear cause hugepage unusable on non-NUMA machine
Date: Tue, 7 Jul 2009 13:14:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       alexs <alex.shi@intel.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.VeE.Z0oUKB@chimera> <4A529180.7090104@kernel.org>
In-Reply-To: <4A529180.7090104@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071314.31943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Yinghai Lu wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13690
> > Subject		: nodes_clear cause hugepage unusable on non-NUMA machine
> > Submitter	: alexs <alex.shi@intel.com>
> > Date		: 2009-07-02 01:22 (5 days old)
> > 
> 
> 
> http://lkml.org/lkml/2009/7/2/326

Thanks, updated.

Best,
Rafael
