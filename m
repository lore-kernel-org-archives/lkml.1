Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXGHAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXGHAxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXGHAxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:53:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:37254 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbXGHAx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:53:29 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, pavel@ucw.cz, paulus@samba.org,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
In-Reply-To: <200707072248.06970.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
	 <200707061131.08475.oliver@neukum.org>
	 <1183776285.3388.201.camel@localhost.localdomain>
	 <200707072248.06970.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 10:50:28 +1000
Message-Id: <1183855828.3388.242.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Well... 2 things here. Either you have a freezer in which case the
> > chances of the above scenario are increased,
> 
> How so? :-)

I meant you have a freezer that freezes uninterruptible tasks.

Ben.


