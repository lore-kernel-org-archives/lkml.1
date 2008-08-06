Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYHFMgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYHFMgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYHFMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:35:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbYHFMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:35:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: 2.6.27-rc1-git4: Reported regressions from 2.6.26
Date: Wed, 6 Aug 2008 14:38:22 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik> <4899710A.60804@tuffmail.co.uk>
In-Reply-To: <4899710A.60804@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061438.22833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of August 2008, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > [Note that all of the suspend/resume regressions seem to result from the same
> > couple of bugs, or even one bug, but since that has not been confirmed yet,
> > they are listed separately.
> > 
> > Bug submitters also please note that if you CC your reports to
> > kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, they will be _much_ easier to track for me
> > and pretty much everybody else.]
> 
> Cool.  Will do so in future.
> 
> Sorry to be a pest, but can you explain why this address is better than
> <kernel-testers@vger.kernel.org>?  It's easier for me to use the latter since I 
> can remember it :-).

That was kernel-testers@vger.kernel.org in the original message.

> > This message contains a list of some regressions from 2.6.26, for which there
> > are no fixes in the mainline I know of.  If any of them have been fixed already,
> > please let me know.
> 
> Thanks, having this list helps build my confidence when testing if anything more
> is broken in rc2 :-).

You're welcome. :-)

Thanks,
Rafael
