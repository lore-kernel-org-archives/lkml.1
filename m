Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZEKLtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZEKLtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZEKLtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:49:06 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:39972 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZEKLtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JPqpUDP+uKe+oHiXBn/STZyomf3u2V3QPHKrtVqNswPD/PHRi60y5wos28CVBWF2r4
         tXinpkIIi34sd3f0nX/i8rdBXGIZjntpN0yMpu2kHYMBMNYh+Iyb0ACZCNQJq1LREaSa
         oN9JXEiFrCZ/5ptejRhc2KjtX/1y58SogyNKc=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	 <20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de>
	 <20090509223454.4642753d.akpm@linux-foundation.org>
	 <20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop>
	 <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	 <ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	 <20090510170016.1e3a4d97@infradead.org>
	 <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
Date: Mon, 11 May 2009 13:49:03 +0200
Message-ID: <b637ec0b0905110449n15340bbepb3a5adc2cee32b28@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, May 11, 2009 at 3:22 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
[BIG snip]
> Devtmpfs is the simplest, is the fastest, is the most reliable, and it
> is the most flexible option for us. And still, nobody will be forced
> to use it, it's entirely optional. For our systems, we decided to do
> it that way, and we ship it already in the distro, and if there are no
> substantial problems coming up, which we don't expect, we will
> continue using it.

Can you please point me to a SuSE kernel that ships with this new feature?
Thanks,
Fabio
