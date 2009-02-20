Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZBTKyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZBTKyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbZBTKyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:54:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZBTKyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:54:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove
Date: Fri, 20 Feb 2009 11:53:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org> <200902192247.46370.rjw@sisk.pl> <m13aeaxaw0.fsf@fess.ebiederm.org>
In-Reply-To: <m13aeaxaw0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201153.52683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Thursday 19 February 2009, Eric W. Biederman wrote:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >> 
> >> >
> >> > There are large-scale and conflicting changes to this file in linux-next.
> >> >
> >> > If we want to jam this fix into 2.6.29 (and it looks like something we
> >> > want) then this will trash the linux-next changes.  It will cause me
> >> > grief, and will cause Stephen grief unless the pci tree is suitably
> >> > changed, which will cause Jesse grief. Either way: grief.
> >> 
> >> Ugh.
> >> 
> >> I had better have a good hard look at linux-next.  I tried to ask earlier
> > about
> >> ongoing working but I didn't hear anything.
> >
> > Yes, you did: http://marc.info/?l=linux-kernel&m=123342565225134&w=4
> 
> My apologies.

No problem. :-)

Rafael
