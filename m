Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbYCDAMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbYCDAMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763736AbYCDALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:11:47 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:36275 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763715AbYCDALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YHVsn9CcLrvEUSLGjQjzvoLz2Lq89Bumph2ldBcccx1lP/+gyHfrB76uckSbHn6z7kaUxLiO85L9/Qw6sXdJYvdrYa83SZynq2j2XhJLzhLN/735A9dl44nvYYXOb+uMayoOTHBEP4M1qpkK4fnUtRciXE57mAz9p20dwzn4ZlM=
Message-ID: <9a8748490803031611m4ad2cd7dr16e30e7cb003c05f@mail.gmail.com>
Date: Tue, 4 Mar 2008 01:11:41 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: 64-bit AMD panic
Cc: "Rik van Riel" <riel@redhat.com>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
	 <alpine.DEB.1.00.0803031942040.5974@sheep.housecafe.de>
	 <20080303162246.3f33ee24@cuia.boston.redhat.com>
	 <Pine.LNX.4.61.0803031704290.7011@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2008, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>
<snip>
>
> That's the problem trying to support devices in production.
>  The last kernel I was able to locate for the x86_64 project
>  is linux-2.6.23. Its dates are from late last year so maybe
>  it will work!
>
>  It is now being compiled one one of the target machines.
>  If this works, I'll have to find the differences between
>  the old and the newer and patch the linux-2.6.11 because
>  it is a "certified" kernel, i.e., selected by the FAA and
>  determined to be politically correct!

So, you take a "certified" kernel, then you patch it, which leaves you
with what? Certainly not a certified kernel. You might as well go with
the latest 2.6.24.3 sources then...

>
<snip>
>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
