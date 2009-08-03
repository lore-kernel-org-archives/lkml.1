Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZHCPSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZHCPSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZHCPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:18:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42139 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZHCPSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:18:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #13865] Can only resume with HP_WMI selected on compaq nc6000 when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
Date: Mon, 3 Aug 2009 17:18:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "cedric" <cedric@belbone.be>, "Matthew Garrett" <mjg@redhat.com>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera> <7ixSg7D88bK.A.qOF.3pgdKB@chimera> <200908030053.27869.elendil@planet.nl>
In-Reply-To: <200908030053.27869.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031718.42937.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Frans Pop wrote:
> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13865
> > Subject	: Can only resume with HP_WMI selected on compaq nc6000 when
> >		  4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
> > Submitter	: cedric <cedric@belbone.be>
> > Date		: 2009-07-29 12:47 (5 days old)
> 
> Fix just made it into mainline: daed953721850381673687c59f3a0df553eb6626

Thanks, closed.

Rafael
