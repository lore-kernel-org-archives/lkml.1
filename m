Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbXIYQen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbXIYQen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXIYQee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:34:34 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:40252 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294AbXIYQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:34:33 -0400
Message-ID: <46F93879.8090203@suse.de>
Date: Tue, 25 Sep 2007 20:34:01 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain>	 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>	 <46F8C880.1010006@suse.de>	 <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>	 <46F8F033.2040402@gmail.com> <64bb37e0709250930m555a9586j35a1d579ea5a3713@mail.gmail.com>
In-Reply-To: <64bb37e0709250930m555a9586j35a1d579ea5a3713@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> Back to debugging this:
> http://marc.info/?l=linux-acpi&m=119052970904643&w=4
> fails to apply against 2.6.23-rc7-mm1, but moving that function by
> hand was not to difficult. ;)
> (With only the second patch I got a link error...)
> 
> http://marc.info/?l=linux-acpi&m=119073173625910&w=4
> applied, and a test showed that my system now powers off again.

Good,
thanks, Alex.
