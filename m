Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbXLNKBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbXLNKBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764034AbXLNKBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:01:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:37266 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762306AbXLNKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:01:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z/C13N2Y1XNb0fhtvq0Z8jb0BRD5jGaXF2g2X1g32tfsKrVsm9389qHdFWyiVndEe9oAE3SE0oA6KHn7rI9XPkrQFpV1/eKXswhIphEdFIbDAa0sk9on8/1WiqfYIw50RVRs6VvoPypqM4f1MIDppeMA3jblGxvSbkvs0Vfqbs0=
Message-ID: <9a8cbed90712140201r6cb287d9w99cc1210c68e8e60@mail.gmail.com>
Date: Fri, 14 Dec 2007 05:01:31 -0500
From: "Arun Thomas" <arun.thomas@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: PROBLEM: E6850 has an 8+ minute delay during boot
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071214015315.09829a99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8cbed90712140110l156a34e3x38533b7710544cf8@mail.gmail.com>
	 <20071214015315.09829a99.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 4:53 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 14 Dec 2007 04:10:31 -0500 "Arun Thomas" <arun.thomas@gmail.com> wrote:
>
> > [   20.185881] Initializing CPU#1
> > [  527.926587] Calibrating delay using timer specific routine..
> > 200566.59 BogoMIPS (lpj=401133185)
>
> Silly question: is that delay actually observeable by a human,
> or is it just a leap in the printk timestamping?

Good question. Yes, it's human-observable. The kernel "hangs" for  8
mins by my wall clock, and then it continues to boot up.

Thanks,
Arun
