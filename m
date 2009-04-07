Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZDGVWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZDGVWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZDGVWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:22:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZDGVWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:22:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #13019] /proc/<pid>/maps offset output broken in 2.6.29
Date: Tue, 7 Apr 2009 23:22:08 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Michael Ellerman <michael@ellerman.id.au>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.9HH.zFn2JB@chimera> <Pine.LNX.4.64.0904070008320.4254@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904070008320.4254@blonde.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072322.09322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Hugh Dickins wrote:
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
> > Subject		: /proc/<pid>/maps offset output broken in 2.6.29
> > Submitter	: "Chris Friesen" <cfriesen@nortel.com>
> > Date		: 2009-04-01 23:18 (6 days old)
> > References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
> > Handled-By	: Hugh Dickins <hugh@veritas.com>
> 
> No, this shouldn't be listed as a regression from 2.6.28: if it's to be
> counted as a regression at all, it's 2.6.23's regression from 2.6.22.
> (We're about to deal with it in 2.6.30, but hardly worth backporting.)

Thanks, dropped from the list already.

Best,
Rafael
