Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXJHOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXJHOeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 10:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXJHOe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 10:34:27 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:22253 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbXJHOe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bmYNUMyhNhPU1xVOOrK1FAWYsuyZw8BnQLGIflCgJNJABLwbHZxC6rJu+4AJq9oSFzcrNj1nS+SAJ6FmLkRDuh+Yy0HtZwHZmpJB6+NdvF8RQwrmASILQ5hdTH1+80oBY622W3IlIrs6N1GGFBgUKkk2tBMNLU+meKxF8PEKlsA=
Message-ID: <1985e0f60710080734y4897a8e1ke253b6d4273146ec@mail.gmail.com>
Date: Mon, 8 Oct 2007 20:04:24 +0530
From: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.23-rc9-rt2
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0710080951270.4846@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191536413.5210.19.camel@localhost.localdomain>
	 <1985e0f60710070635l7016bad1t9c4d4cb1a966534f@mail.gmail.com>
	 <Pine.LNX.4.58.0710080951270.4846@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On 10/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> --
> On Sun, 7 Oct 2007, Jaswinder Singh wrote:
>
> > Do you have any plans to support nested or reentrant Interrupt Handling schemes.
> >
>
> Hi Jaswinder,
>
> Not sure what you mean by this, since interrupt handlers are run as
> threads and are fully preemptible.
>

I think by nested or reentrant interrupt handling technique you can
further reduce latencies.
what you think.

Can we can get guaranteed realtime throughput by using these realtime patch.

Thank you,

Jaswinder SIngh.
