Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXCFRXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXCFRXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXCFRXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:23:23 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:18389 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbXCFRXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nV77oH5ra/vINR80CUOOtMyqYY6rCaF9sh7fSE8cO3ssBykWm4XSCPV6Va+33eERxfjvU6JGvfIrPZgqmp6k1O7IarE3cgGaTjjuz9GsJaUgh3JXvboZgIJbHiKvD/Rk88OkFHnSqW/nk5ZZ+o/ekbUuiHVNdddmxfzBYxQGmsM=
Message-ID: <75b66ecd0703060923yc73b796w3aae193ed5f8d9ee@mail.gmail.com>
Date: Tue, 6 Mar 2007 12:23:21 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "devzero@web.de" <devzero@web.de>
Subject: Re: [RFC] BadRAM still not ready for inclusion ? (was: Re: Free Linux Driver Development!)
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, pavel@suse.cz
In-Reply-To: <1663310550@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1663310550@web.de>
X-Google-Sender-Auth: 94b70620b63ae316
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, devzero@web.de <devzero@web.de> wrote:
> It seems, that BadRAM is not being maintained very actively and the original author doesn`t seem to have the time pushing it into mainline, but i know it's actively being used by more then just a handful of people. Unfortunately there is no mailinglist to approve this and some "central point of communication" besides Rick van Rein doesn't seem to exist. There is a fork named BadMEM at http://sourceforge.net/projects/badmem, Memtest86 also supporting BadRAM and i have seen LOTs of discussion about BadRAM on the net. Most of that discussion was due to problems getting it run with Kernel XYZ.
>
> Basically, this feature is a matter of adding/modifying 200 lines of code, so iém even more wondering, why it exists for more than 7 years and nothing happening here.

Because most kernel developers don't have time to scour the net for
random kernel patches and pull them.  If you have a useful patch you
want merged it's up to you to push it.

What's so hard about submitting a 200 line patch to LKML?

Lee
