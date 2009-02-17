Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZBQPBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZBQPBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZBQPB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:01:29 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36647 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZBQPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:01:28 -0500
Subject: Re: [RFD] Automatic suspend
From: Igor Stoppa <igor.stoppa@nokia.com>
Reply-To: igor.stoppa@nokia.com
To: ext Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20090217145141.GA26158@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com>
	 <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com>
	 <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl>
	 <20090216232329.GA15678@srcf.ucam.org>
	 <20090217142001.GB12378@bulgaria.corp.google.com>
	 <20090217064630.688bf639@infradead.org>
	 <20090217145141.GA26158@srcf.ucam.org>
Content-Type: text/plain
Organization: Maemo Software - Nokia Devices R&D
Date: Tue, 17 Feb 2009 16:58:22 +0200
Message-Id: <1234882702.2343.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2009 14:58:25.0912 (UTC) FILETIME=[2F7EE780:01C99110]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tue, 2009-02-17 at 15:51 +0100, ext Matthew Garrett wrote:
> On Tue, Feb 17, 2009 at 06:46:30AM -0800, Arjan van de Ven wrote:

> Remember that Android has an open marketplace designed to appeal to Java
> programmers - users are going to end up downloading code from there and
> then blaming the platform if their battery life heads towards zero. I
> think "We can't trust our userland not to be dumb" is a valid concern.

It took few years of preaching but eventually our (admittedly small)
userbase did start to see the truth and not blame the platform but
rather the applications they had installed on top of it.

Powertop is a good tool.

Maybe slamming a nice GUI on top of that would turn all the userbase
into a horde of bug reporters for the offending apps.

Or maybe it's just wishful thinking ....  :) 

-- 

Cheers, Igor

---

Igor Stoppa
Maemo Software - Nokia Devices R&D - Helsinki

