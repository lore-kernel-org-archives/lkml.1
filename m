Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbXJAVui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbXJAVui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJAVua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:50:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12394 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXJAVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UbeN0icOc/7FNU/Tv+0AhuexDs6fAMVQ7uYNKP1NEFTPii/Ca7jztl4r48NMUmwm49Y9sXPzfod2OzX++oOSNbHrSrbHZQ+bqbQ6gZViGNJDv2VzZSu+sBYE0qLN++3eBHOqFKXndKnXRsMrsqfEAcF7mmmfrlAqmviW2KjU2no=
Message-ID: <47016AFB.7040307@googlemail.com>
Date: Mon, 01 Oct 2007 23:47:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-10-01-04-09.tar.gz uploaded
References: <200710011115.l91BFRvg012762@imap1.linux-foundation.org>
In-Reply-To: <200710011115.l91BFRvg012762@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-10-01-04-09.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-10-01-04-09.tar.gz
> 
> It contains the following patches against 2.6.23-rc8:

I have a question about these snapshots , what is the right way to apply the patches ?
some magic script ? =)

I have myself a small script which extracts the list of patches for the email and patch in 
that order but I always get a few hunks so I'm not sure is really the right way of doing that.

The resulting kernel does build on my setup but won't boot.Died with grub error 28:

'Selected item cannot fit into memory'

2.6.23-rc8-mm2 booted fine here with the same config.

( http://194.231.229.228/config-broken-out-2007-10-01-04-09 )

Regards,

Gabriel

