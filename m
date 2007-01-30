Return-Path: <linux-kernel-owner+w=401wt.eu-S965651AbXA3RzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651AbXA3RzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXA3RzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:55:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:39458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965651AbXA3RzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FCwfu2tn9uSc8r4DBC7QNIMDY0OFSLv29iaGPO6Rx98ByHR837w3d6ZnwTRxZ6Udq78dLEOJi4tAScngh7MMbR7i80zHgSFyNuGd+V8aeg50fn7hE96rbGqOOR0XsnrZ9N74/fHsqCddJ2XYtG0ILGR+USaKBWxhw5B1rYXTLuI=
Message-ID: <1a297b360701300955g150dc109h4a12139f8db01b41@mail.gmail.com>
Date: Tue, 30 Jan 2007 21:55:15 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <ada8xfks90x.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > All that is needed is some kind of specification that describes how your
>  > device works, or the email address of an engineer that is willing to
>  > answer questions every once in a while.  A few sample devices might be
>  > good to have so that debugging doesn't have to be done by email, but if
>  > necessary, that can be done.
>
>  > This driver will work with all[1] of the different
>  > CPU types supported by Linux, the largest number of CPU types supported
>  > by any operating system ever before in the history of computing.
>
>  > As for support, the driver will be supported through email by the
>  > original developers, when they can help out, and by the "enterprise"
>  > Linux distributors as part of their service agreements with their
>  > customers.
>
> I'm all for openness of device programming specs, but I think it's a
> bit disingenous to suggest that all a company has to do to get a
> driver written and supported is throw some documentation over the
> wall.  And it's crazy to suggest that the driver will work on every
> platform and be supported by enterprise distros.
>
> Just look at the in-tree drivers: there are tons of them that don't
> work on big-endian platforms, or have 64-bit problems, or have no SMP
> support.  And that doesn't even count drivers that are so bitrotted
> they won't even build any more.  And there are plenty of documented
> devices that no one cares enough about to submit a driver for.
>
> In the real world, a vendor that wants to make sure a device is
> supported by Linux had better pay someone to write the driver and keep
> it working.  Of course, if the device is popular enough or simple
> enough, docs are all that's needed, but in many cases no one competent
> to write the driver is going to volunteer to do it.


Well, if the hardware is nice and is useful to many, there will be at
least a few handful who would ready to put in some effort to it. (We
are talking complex hardware only, not simple ones) Of course
development takes some time, in the order of a few months as opposed
to weeks. The vendor can of course the pay the author as well, which
will result in even better support.


regards,
manu
