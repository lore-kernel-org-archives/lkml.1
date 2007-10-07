Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJGNf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJGNf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 09:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJGNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 09:35:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:15542 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXJGNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 09:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MlKhZ7OD2ZGMk+M7zp5KzFEaF9w4Af7RZGKTKwuZramT7Jds4ZpG4kRSoD8LZZ8pqhm8Gk9FpCLYjmeGHdYecAelaBBpMQ0eRhrzhH9D/0ZErEiwOMOPj9uQmgLg25nljCmpGRSgp4V4D0TrituhOSrNQ6KQxko70UxOZ93xjhg=
Message-ID: <1985e0f60710070635l7016bad1t9c4d4cb1a966534f@mail.gmail.com>
Date: Sun, 7 Oct 2007 19:05:17 +0530
From: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.23-rc9-rt2
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1191536413.5210.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191536413.5210.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steve,

Do you have any plans to support nested or reentrant Interrupt Handling schemes.

Thank you,

Jaswinder SIngh.

On 10/5/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.23-rc9-rt2 tree, which can be
> downloaded from the new location:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Changes since 2.6.23-rc9-rt1
>
>   - x86_64 disable IST for debug (Andi Kleen)
>
>   - Better handling of dynticks going bad in RCU (Steven Rostedt)
>
>   - Preempt RCU boosting (Steven Rostedt based on Paul E. McKenney's
>     stuff)
>
> Again, this still holds experimental code. But I've been running it on a
> few boxes already (and even the box I'm writing this on).
>
> to build a 2.6.23-rc9-rt2 tree, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.23-rc9.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rc9-rt2.bz2
>
> The broken out patches are also available.
>
> -- Steve
>
>
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
