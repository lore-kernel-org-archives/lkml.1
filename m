Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbXJWJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbXJWJLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXJWJLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:11:06 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:8398 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXJWJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EsO4YiP2Jv6oQ1R1wm5S8gaz93eyiZPWgbXdNUFb5HNVREtgG7MVn/Vu0Rz2oFa1rKsqB2yJyMJG0YRXpxPvWfcAFyEgpTN/83sMfUmtRhEBAOi6+eLmCW21JgOdNHEdid5s5HIQVdrV5M2RWl6XD2q17HMTOOuMwPd6Jz1njgw=
Message-ID: <efe7343f0710230211h53037226p874e6a2fd67f0088@mail.gmail.com>
Date: Tue, 23 Oct 2007 10:11:02 +0100
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Cc: "Pavel Machek" <pavel@ucw.cz>, "Daniel Hazelton" <dhazelton@enter.net>,
       "Ivo van Doorn" <ivdoorn@gmail.com>, "Dan Williams" <dcbw@redhat.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
In-Reply-To: <20071023090808.GB19758@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071020184100.GA11640@elf.ucw.cz>
	 <20071022211325.GF28190@elf.ucw.cz>
	 <200710222352.57543.IvDoorn@gmail.com>
	 <200710221742.36693.dhazelton@enter.net>
	 <20071022220000.GH28190@elf.ucw.cz>
	 <20071023090808.GB19758@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 10/23/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Oct 23, 2007 at 12:00:00AM +0200, Pavel Machek wrote:
> > there's nothing to suggest otherwise, and there's explicit:
> >
> > #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> > #define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
> > MODULE_LICENSE("GPL");
>
> So what about contacting the vendor and asking?
>

this is no longer a rt2x00 issue, maybe we all could keep it away from
the rt2400-devel list?

thanks,
Luis Correia
rt2x00 project administrator
