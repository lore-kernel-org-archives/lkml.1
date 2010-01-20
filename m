Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659Ab0ATVJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0ATVJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369Ab0ATVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:09:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33717 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0ATVJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:09:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Wed, 20 Jan 2010 22:09:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1001201005380.1672-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001201005380.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202209.29207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010, Alan Stern wrote:
> On Tue, 19 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > Why change the name from "level" to "runtime"?
> > 
> > Because it wouldn't be really obvious what "level" applied to.  For example,
> > some people might expect the values of "level" to correspond to PCI power
> > states for PCI devices and so on, so it might turn out to be confusing. 
> 
> But is the name "runtime" any clearer?  Especially to people who have 
> never come across the phrase "runtime power management"?
> 
> Does anybody have a suggestion for a better attribute name?

Apparently not, but I can try. ;-)

* status

* power (power/power looks weird, but the values would make sense)

* control

No more ideas for now.

Rafael
