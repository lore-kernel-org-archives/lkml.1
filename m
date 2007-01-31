Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXAaX72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXAaX72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933364AbXAaX72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:59:28 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:45546 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365AbXAaX71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=S83wKudTKIUZ0CuFWRZ/TOTlhBWdvMK1rp8XS5LYQIrKiPYUP2MLoL2E2Ujh6GGmWWJEKSYxJdgDxvy89zfLWIaeugZXGuEw3OzgEDuG4lwez1osGjLy27Lk2+rgNZEVrTllNvtw8Fb9g/3pNWLL6cu3dvEYyC8qnO5cRqmT8sc=
Message-ID: <75b66ecd0701311559u2c1f44f9t685b3054802d9cc3@mail.gmail.com>
Date: Wed, 31 Jan 2007 18:59:26 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Theodore Tso" <tytso@mit.edu>, "Greg KH" <greg@kroah.com>,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <20070131230014.GD20514@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
X-Google-Sender-Auth: d7a6a5208118ac1b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Theodore Tso <tytso@mit.edu> wrote:
> More specifically, Dave said that it "seemed rude" to just take the
> driver and send updates, but maybe the best way of dealing with
> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
> kind of spec release, and just have someone in the community forcibly
> take the code, fix it up, and then get it merged.

But if the maintainer is unwilling to work with the kernel developers,
the driver won't get bugfixes or updates for new hardware.

Lee
