Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZBRRIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZBRRIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZBRRIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:08:14 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:42163 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZBRRIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:08:13 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 18:10:01 +0100
User-Agent: KMail/1.9.10
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902181135400.3186-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902181135400.3186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902181810.03679.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wednesday 18 February 2009 17:39:21 schrieb Alan Stern:
> In essence what you're saying is that we won't be able to do
> link-suspend for HID until something like HID transport classes (or
> something simpler, devoted specifically to runtime PM) is implemented.  
> And likewise for other subsystems.  I can't argue with this conclusion.

I'd say, if it has sensible operations, it is a device and should be in the
tree as such.

	Regards
		Oliver

