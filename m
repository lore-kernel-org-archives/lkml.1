Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZDTEcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZDTEcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZDTEcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:32:12 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1372 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZDTEcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:32:11 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'David Miller'" <davem@davemloft.net>, "holt@sgi.com" <holt@sgi.com>
cc: "Matthew Carlson" <mcarlson@broadcom.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Date: Sun, 19 Apr 2009 21:31:53 -0700
Subject: Re: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC
 addresses on BCM5701
Thread-Topic: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC
 addresses on BCM5701
Thread-Index: AcnAp5L3BRmkMgJDQ/mJBPGRHAMjNQA0XkLQ
Message-ID: <C27F8246C663564A84BB7AB343977242177D75A05C@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20090418.213011.50580925.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 65F525303D424873175-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>
> From: Robin Holt <holt@sgi.com>
> Date: Fri, 17 Apr 2009 07:21:21 -0500
>
> >> Actually, I think we do have a fix for this.  James and Robin both
> >> reported that the test patch I sent out worked for them.
> I'm preparing
> >> a patchset for submission now.
> >>
> >> James, Robin, can you confirm that you performed your
> tests with David's
> >> patch reverted?
> >
> > My test was done with the 2.6.28-rc1 kernel plus your patch and no
> > others.
>
> Can I get a final patch against Linus's current tree?
>

Matt should be able to provide a patch tomorrow.  We're still discussing
this with Grant Grundler on the parisc list.

