Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbXFLWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbXFLWJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXFLWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:09:09 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:49051 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbXFLWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fL+yMDqhc1LzhA/UfNWDrqToLeWAwuGu5F6F5DAzLSlycAQQSouGUC2ryAMTaRk1JNdRZliZrZYgXzZjDBVFKKp5tcahbEuAeDSGfvF5zDYJ001YUgziczj9lZ0JnVXfV0ClO895GDm9o5OuVzj5g68YMeWRToHQDk+RMLbmM7A=
Message-ID: <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
Date: Tue, 12 Jun 2007 15:09:03 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: raid5: coding style cleanup / refactor
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
X-Google-Sender-Auth: b45cd39ce7acaa34
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I assume that you're prepared to repair all that damage to your tree, but
> > it seems a bit masochistic?
>
> It's either this or have an inconsistent coding style throughout
> raid5.c.  I figure it is worth it to have reduced code duplication
> between raid5 and raid6, and it makes it easier to add new cache
> features going forward.  I have a few more cleanups to add for a rev2 of
> this patch, but I will hold that off until the rebase is done.
>

In other words, it seemed like a good idea at the time, but I am open
to suggestions.
