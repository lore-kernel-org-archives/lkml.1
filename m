Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZB0PR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZB0PR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZB0PRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:17:47 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48907 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZB0PRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:17:47 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFD] Automatic suspend
Date: Fri, 27 Feb 2009 16:22:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc6-next-20090226-9-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902191356.53584.rjw@sisk.pl> <200902231504.27879.oliver@neukum.org> <20090227101818.GH4582@elf.ucw.cz>
In-Reply-To: <20090227101818.GH4582@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271622.25141.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 Februar 2009 11:18:18 schrieb Pavel Machek:
> > We can just as well have a class of tasks less important than power
> > saving. They'd just run when power saving is not active for some other
> > reason. Just like other such schemes we end up with the problem
> > of priority inversion with locking.
>
> Ok, I guess this could be interesting in some cases... maybe. What are
> real examples of such tasks?

The classical example is Seti@HOME. Any monitoring tool like umtsmon
or kwifimanager.

	Regards
		Oliver

