Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYBKHtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYBKHtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYBKHtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:49:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:37674 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYBKHtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=neAJfq4pPz2l+ZS7wh7lVKKr5P/lOLXj+Qt7DOXnY6Q+3nzE65gC1ckKrw6mjxzstwiWGy/eytc9lGz1v4u+/cCm+M/K/vuNKgsl+DsTaUZwBFBiC3kZ2b7J/ndhqtAf+1oaxjsQ6sdJDdpJygo0Duv/tr36kOI4IMX5XACCZuA=
Message-ID: <84144f020802102349h6e9222cdpf991cf4e368b5e93@mail.gmail.com>
Date: Mon, 11 Feb 2008 09:49:44 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [PATCH] vmsplice exploit fix (was: splice: fix user pointer access in get_iovec_page_array)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       bastian@waldi.eu.org, ndenev@gmail.com, oliver.pntr@gmail.com
In-Reply-To: <200802102329.50843.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
	 <200802102329.50843.phillips@phunq.net>
X-Google-Sender-Auth: 38666f590c152f78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Feb 11, 2008 9:29 AM, Daniel Phillips <phillips@phunq.net> wrote:
> I think many users would first go to kernel.org on a day like today, as
> I did.  Nothing to see there.  We could do a way better job of getting
> the word out.

Any suggestions what I could have done better here? As soon as Linus
merged the patch, I sent it to stable@kernel.org and expected
information to spread from there. I did also follow up on some vendor
bugzillas (Debian, RHEL, Fedora) to make sure they were aware of the
merged patch (they were).

                                    Pekka
