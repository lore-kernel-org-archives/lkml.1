Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYBQELV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYBQELV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYBQELB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:11:01 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:29811 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbYBQEK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ns95mVVtBRyzkCDYzYOgpY7OSaoq/ourUnD7b4dORrrkG40/Lox9+1yTY4aV0aKhEpoWFslZmPCyKDgz3+e9Y0aEmOPR5ZmEdyyiPtUrSdD8IFIPmATdbFT177jHVkQ6k8pUsrz6xEzGxIXBdohxUEdru43fmvYUAPf9tW5Ht6Y=
Date: Sat, 16 Feb 2008 23:10:53 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Buehler <abuehler.kernel@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [OT] GMail (was USB regression (and other failures)...)
Message-ID: <20080217041052.GA32381@nineveh.local>
Mail-Followup-To: Andrew Buehler <abuehler.kernel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0802161756330.3753-100000@netrider.rowland.org> <47B78A08.1020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B78A08.1020502@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 08:12:40PM -0500, Andrew Buehler wrote:
> [...] and I would not be in the least surprised if this turned out to
> be yet one more problem with gmail

It is; Gmail will refuse to POP more than one copy of a mail to you,
no matter how many copies it recieves via different paths.  Which copy
you get seems to be dependant on which arrives first, so you can't
even hope a mail exchange will consistently arrive in one mailbox or
another.

Note that this also applies to mails cross-posted to multiple lists
you maybe be suscribed to; this breaks threading fantastically.

Google is aware of the issue, and considers it a feature.  If you find
another free mail service which isn't so broken, I'd love to hear
about it.

---

That said, netiquette on the kernel lists is to *never* drop CC's.
Too much traffic crosses the lists for anyone to read it all and note
anything they might be interested and/or implicated in.  Never
dropping CC's allows busy people to keep track of conversations
they've taken part in or that someone thinks they should see
without the worry of missing any important parts of one.

Or at least it does if your mail system isn't broken.  We get what we
pay for.  :-/

--
Joseph Fannin
jfannin@gmail.com
