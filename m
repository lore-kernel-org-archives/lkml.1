Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZGGULF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZGGULF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZGGUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:10:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZGGUKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:10:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>, Len Brown <lenb@kernel.org>
Subject: Re: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
Date: Tue, 7 Jul 2009 22:11:08 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       rui.zhang@intel.com
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.BN.NBpUKB@chimera> <200907072119.59171.elendil@planet.nl>
In-Reply-To: <200907072119.59171.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072211.08609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Frans Pop wrote:
> On Tuesday 07 July 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
> > Subject	: Warning 'Invalid throttling state, reset' gets displayed when
> >		  it should not be 
> > Submitter	: Frans Pop <elendil@planet.nl> 
> > Date		: 2009-05-26 15:24 (42 days old)
> > Handled-By	: Frans Pop <elendil@planet.nl>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
> > 		  http://bugzilla.kernel.org/attachment.cgi?id=21672
> 
> I still have not received any reaction from the ACPI maintainers to the 
> bug or the proposed patches.

Sorry for that.

Len, what do you think of the patches listed above?

Rafael
