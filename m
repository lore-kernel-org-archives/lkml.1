Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYBKIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYBKIA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYBKIAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:00:48 -0500
Received: from phunq.net ([64.81.85.152]:37778 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753676AbYBKIAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:00:47 -0500
From: Daniel Phillips <phillips@phunq.net>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] vmsplice exploit fix (was: splice: fix user pointer access in get_iovec_page_array)
Date: Mon, 11 Feb 2008 00:00:43 -0800
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       bastian@waldi.eu.org, ndenev@gmail.com, oliver.pntr@gmail.com
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI> <200802102329.50843.phillips@phunq.net> <84144f020802102349h6e9222cdpf991cf4e368b5e93@mail.gmail.com>
In-Reply-To: <84144f020802102349h6e9222cdpf991cf4e368b5e93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110000.43789.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008 23:49, Pekka Enberg wrote:
> Hi Daniel,
>
> On Feb 11, 2008 9:29 AM, Daniel Phillips <phillips@phunq.net> wrote:
> > I think many users would first go to kernel.org on a day like
> > today, as I did.  Nothing to see there.  We could do a way better
> > job of getting the word out.
>
> Any suggestions what I could have done better here?

You did your part flawlessly as far as I can see.  Really, your original 
subject line was accurate, and lkml should not be the place to go to 
find the patch, but it is.

> As soon as Linus 
> merged the patch, I sent it to stable@kernel.org and expected
> information to spread from there. I did also follow up on some vendor
> bugzillas (Debian, RHEL, Fedora) to make sure they were aware of the
> merged patch (they were).

And they are no doubt getting kernel revs out at this very moment, that 
part of the machine works great.  It is just the part about getting out 
information to users who want to patch their own kernels that could be 
done better.

Regards,

Daniel
