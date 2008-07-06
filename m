Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYGFROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYGFROm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYGFROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:14:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbYGFROd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:14:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [Bug #10861] 2.6.26-rc4-git2 - long pause during boot
Date: Sun, 6 Jul 2008 19:16:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Clayton <chris2553@googlemail.com>,
       Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.teC.90LcIB@albercik> <1215354787.4197.1.camel@localhost.localdomain>
In-Reply-To: <1215354787.4197.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807061916.18401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of July 2008, James Bottomley wrote:
> On Sun, 2008-07-06 at 13:45 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> Erm, this isn't a kernel regression, it's a udev rule problem.
> 
> The rule has been identified and fixed; the reporter confirms it fixes
> the problem and the upstream maintainer of udev is putting out a release
> with it in ... what more exactly needs to be done?

Closed as "invalid".

Thanks,
Rafael
