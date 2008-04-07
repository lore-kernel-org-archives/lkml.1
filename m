Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYDGXSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYDGXSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYDGXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:18:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYDGXSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:18:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.25-rc8-git5: Reported regressions from 2.6.24
Date: Tue, 8 Apr 2008 01:18:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200804071459.35628.rjw@sisk.pl> <47FAAA10.4030509@qumranet.com>
In-Reply-To: <47FAAA10.4030509@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080118.55990.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of April 2008, Avi Kivity wrote:
> Rafael J. Wysocki wrote:
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
> > Subject		: kvm: INFO: inconsistent lock state
> > Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date		: 2008-03-05 03:26 (34 days old)
> >
> >   
> 
> This is benign; will fix, likely post 2.6.25 as the fix in non trivial.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
> > Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
> > Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date		: 2008-02-28 11:25 (40 days old)
> > References	: http://lkml.org/lkml/2008/2/28/106
> >
> >   
> 
> Marcelo fixed this a few days ago; I'll post my 2.6.25 queue soon.
> 
> Can you bcc subsystem maintainers with entries on this list?  Or perhaps 
> those that opt-in?

In the future I will send an automatic reply message to the report for each
regression listed and the CCs will be added to these messages.  This is still
under development, though, so please be patient.

Thanks,
Rafael
