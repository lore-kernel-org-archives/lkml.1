Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYCYPMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYCYPMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYCYPMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:12:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37784 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754780AbYCYPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:12:30 -0400
Date: Tue, 25 Mar 2008 11:12:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 3)
In-Reply-To: <200803242318.21052.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803251111260.4838-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Rafael J. Wysocki wrote:

> The patch below should address all of your comments above.  It also seems to
> work.
> 
> If it looks good to you, please let me know and I'll repost it in a new thread
> along with the platform and PCI patches adapted to it.

I don't see anything else to change.  ACK.

Alan Stern

