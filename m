Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXGLNWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXGLNWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbXGLNWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:22:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:57586 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760726AbXGLNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=VNc6x01A6f6WLV5uO2tQY8eR0rjg1rBwJ7CULyfPclkkkI9dQVoTFylpPnlbCQ1n6rN8Sf4JyxEwvGCvf8PELYUHtS8Lyt4ItTxpADFxpR2gdjHTdnZ8U5DAIQ1+wTZqOx9k7p1bNoOqI3FQC6ZwivRjlFFcLlm6gvJJh4tZImY=
Message-ID: <46962B10.3040909@gmail.com>
Date: Thu, 12 Jul 2007 18:52:24 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: david@lang.hm, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <1184260683.9346.91.camel@caritas-dev.intel.com> <Pine.LNX.4.64.0707120247230.25614@asgard.lang.hm> <200707121501.03016.rjw@sisk.pl>
In-Reply-To: <200707121501.03016.rjw@sisk.pl>
X-Enigmail-Version: 0.95.2
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
[snip]
> 
> So if a user wants to install a kernel.org kernel on his system, (s)he'll have
> to compile and install two kernels with different options.
> 
> That doesn't sound good to me. :-)
> 

definitely. that sounds kind of strange, not to think of having to
remember which kernel to choose on booting.

would it be possible to have the same kernel (or image) act as both
kernel 'a' & 'b', kind of like operating in two different modes.

the kexec-style-hibernate does sound more appealing though..

> Greetings,
> Rafael

-jb
-- 
Tact is the art of making a point without making an enemy.
