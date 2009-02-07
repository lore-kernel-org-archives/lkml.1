Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZBGNyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZBGNyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 08:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZBGNxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 08:53:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZBGNxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 08:53:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roland Dreier <rdreier@cisco.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #12491] i915 lockdep warning
Date: Sat, 7 Feb 2009 14:53:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       intel-gfx@lists.freedesktop.org
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <F169D4F5E1F1974DBFAFABF47F60C10A1DFD867C@orsmsx507.amr.corp.intel.com> <adabptfc90m.fsf@cisco.com>
In-Reply-To: <adabptfc90m.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071453.31570.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 February 2009, Roland Dreier wrote:
> [intel-gfx CC added]
> 
>  > I tested this on my 965 based system that showed the issue and it seemed resolved, at least no warnings in dmesg.  Lockdep was confirmed to still be enabled.
> 
>  > I can mark the bug fixed in korg bugzilla too.
> 
> Probably we just want to add a comment saying the patch works

Yes, I have already added this information to the bug entry.

> -- the bug should stay open until we get the fix upstream I guess.

Yes, the bug will be closed as soon as it's fixed upstream.

Thanks,
Rafael
