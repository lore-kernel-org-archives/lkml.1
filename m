Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZADCvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZADCvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZADCvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:51:00 -0500
Received: from doppler.zen.co.uk ([212.23.3.27]:55110 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZADCu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:50:59 -0500
Message-ID: <49602375.6020409@csr.com>
Date: Sun, 04 Jan 2009 02:48:21 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031924.15869.rob@landley.net> <200901031927.07670.rob@landley.net>
In-Reply-To: <200901031927.07670.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: PATCH [1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
 (v2)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on localhost)
X-Originating-Smarthost02-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Replace kernel/timeconst.pl with kernel/timeconst.sh.  The new shell script
> is much simpler, about 1/4 the size, and runs on Red Hat 9 from 2003.
> 
> It requires a shell which can do 64 bit math, such as bash, busybox ash,
> or dash running on a 64 bit host.

I use Ubuntu (hence dash) on 32 bit systems so I think this needs to 
work with dash on 32 bit hosts.

David
