Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934Ab0ATWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0ATWRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660Ab0ATWRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:17:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0ATWRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:17:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Wed, 20 Jan 2010 23:17:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1001201637001.1360-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001201637001.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202317.46293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010, Alan Stern wrote:
> On Wed, 20 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > Does anybody have a suggestion for a better attribute name?
> > 
> > Apparently not, but I can try. ;-)
> > 
> > * status
> > 
> > * power (power/power looks weird, but the values would make sense)
> > 
> > * control
> > 
> > No more ideas for now.
> 
> I vote for "control".

OK, if no one objects, I'll use that in the next "release" of the patch.

Rafael
