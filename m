Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965Ab0ASX0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0ASX0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080Ab0ASX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:26:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab0ASX0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:26:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Update][RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Wed, 20 Jan 2010 00:27:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1001191035150.1437-100000@iolanthe.rowland.org> <201001192132.26765.rjw@sisk.pl>
In-Reply-To: <201001192132.26765.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001200027.12466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010, Rafael J. Wysocki wrote:
> On Tuesday 19 January 2010, Alan Stern wrote:
> > On Mon, 18 Jan 2010, Rafael J. Wysocki wrote:
... 
> > Don't forget to add an entry to Documentation/ABI/testing/.
> 
> OK

Actually, not in this patch.

There doesn't seem to be room for the /sys/devices/.../power/* attributes at
all right now and I don't think this particular patch is the right one for
adding them all.

Rafael
