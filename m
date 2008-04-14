Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYDNMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYDNMeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYDNMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:34:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYDNMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:34:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 14:34:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: benh@kernel.crashing.org, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <1208126822.6958.63.camel@pasglop> <200804132147.03579.david-b@pacbell.net>
In-Reply-To: <200804132147.03579.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141434.31329.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, David Brownell wrote:
> On Sunday 13 April 2008, Benjamin Herrenschmidt wrote:
> > I think we should get it right now. There's no hurry in pushing things
> > especially if they aren't quite right.
> 
> There is Rafael's patience to remember... (rev 8?)

Yeah.  And rev. 1 was posted something like ... a month ago.
