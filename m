Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXIYLtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXIYLtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXIYLs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:48:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbXIYLs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:48:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Daniel Ritz" <daniel.ritz@gmx.ch>
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Date: Tue, 25 Sep 2007 14:03:02 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Damien Wyart <damien.wyart@free.fr>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       akpm@linux-foundation.org, astarikovskiy@suse.de,
       Len Brown <lenb@kernel.org>
References: <20070925110220.189530@gmx.net>
In-Reply-To: <20070925110220.189530@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251403.03519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 13:02, Daniel Ritz wrote:
> does that one help?
> 
> [ as attachment since i'm on webmail ]
> 
> ACPI: acpi_sleep_prepare() should not depent on CONFIG_SUSPEND
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

An alternative fix for this has been sent to Len:

http://marc.info/?l=linux-kernel&m=119052978117735&w=4

Please test.

Greetings,
Rafael
