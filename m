Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312Ab0AKXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0AKXtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775Ab0AKXtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:49:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0AKXtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:49:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [Bug #15033] drm: gem_object_free without struct_mutex
Date: Tue, 12 Jan 2010 00:50:09 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wilson <chris@chris-wilson.co.uk>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.zcG.3MlSLB@chimera> <alpine.LSU.2.00.1001112304480.6409@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1001112304480.6409@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001120050.09451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 January 2010, Hugh Dickins wrote:
> On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15033
> > Subject		: drm: gem_object_free without struct_mutex
> > Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > Date		: 2009-12-30 19:45 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126220236201529&w=4
> > Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Thanks, Rafael: please close it now.  I just checked latest -git
> and it is now fixed (but not fixed in 2.6.33-rc3) - thanks, Chris.

Thanks, closed.

Rafael
