Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXKTBdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXKTBdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXKTBdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:33:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:2468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXKTBdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:33:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FYFHy5ikkI52qYwl8yLDYSUfBVy7CqTKMhExfhl6DvWOQ+JmIYhjHJCtdv8fqmqu7IYJ9RWwTj7QJzoaUkVzvo9dkjbUEGEzB3UMXRPVof5VgqjUH6P7xCQg6hZNSeumjmzSk40T8IQAtAsTnVLuwirBapnyRObXH6HbHvDZI3k=
Message-ID: <3ae72650711191733r565f98dbh464b31d4497d23b2@mail.gmail.com>
Date: Tue, 20 Nov 2007 02:33:43 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "David Miller" <davem@davemloft.net>
Subject: Re: linux-usb-devel@vger created...
Cc: greg@kroah.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, david-b@pacbell.net
In-Reply-To: <20071119.161755.101979554.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071119.144609.240248721.davem@davemloft.net>
	 <20071119225455.GA23892@kroah.com>
	 <20071119.161755.101979554.davem@davemloft.net>
X-Google-Sender-Auth: 6c10eb02d61cafbe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2007 1:17 AM, David Miller <davem@davemloft.net> wrote:
> From: Greg KH <greg@kroah.com>
> Date: Mon, 19 Nov 2007 14:54:55 -0800
>
> > Woah, the linux-usb-devel@sf.net list is NOT a subscriber-only list at
> > all.  It's wide open with a bunch of mailman rule filter to try to
> > handle the worst of the spam.
> >
> > It does complain if you try to add too many cc:s to it, but that's it,
> > an admin (me or Stephen) will usually get around to aproving them within
> > 24 hours.
>
> Ok, I stand corrected.
>
> > But, I have no objection to moving to vger if you want to handle the
> > admin load.  If so, should I send you a list of addresses that were on
> > the sf.net list so that people can be migrated?
>
> We don't do migrations like that, so that people:
>
> 1) Learn how to subscribe, and thus how to unsubscribe.
>
> 2) Don't get upset that they were added to a mailing list
>    site they may not want to be one.
>
> So I'd ask that you send an announcement out to the old list,
> and during a transition period you can subscribe the old
> list onto the vger one.
>
> Neil B. did something similar recently for linux-nfs, perhaps
> you can ask him how he handled it.

Sounds all good. If that migration works well, please let us do the
same for hotplug.

Kay
