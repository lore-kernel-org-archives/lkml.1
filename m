Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXL0WVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXL0WVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXL0WVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:21:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44318 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbXL0WVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:21:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [RFC][PATCH 0/7] Fix the ACPI 1.0 vs ACPI 2.0 suspend ordering issue
Date: Thu, 27 Dec 2007 23:40:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl> <200712271808.26995.carlos@strangeworlds.co.uk>
In-Reply-To: <200712271808.26995.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712272340.42866.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of December 2007, Carlos Corbacho wrote:
> On Thursday 27 December 2007 18:03:52 Rafael J. Wysocki wrote:
> > Please review (and test, if possible).
> 
> Suspend now works properly here with this patch set.
> 
> Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

Thanks a lot for testing!

Greetings,
Rafael
