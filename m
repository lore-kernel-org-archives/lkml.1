Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZDNQEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZDNQEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDNQEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:04:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZDNQEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:04:35 -0400
Message-ID: <49E4B2D0.3090209@zytor.com>
Date: Tue, 14 Apr 2009 08:59:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
       alan-jenkins@tuffmail.co.uk, Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu> <20090413042459.GA6479@elte.hu> <49E367E8.7080202@zytor.com> <9b2b86520904131134y26f508ffr2bc0303eff203a25@mail.gmail.com> <49E38DBD.8040303@linux.intel.com> <20090414000627.GL817@elte.hu> <49E41447.2060400@zytor.com> <49E4517B.4020301@goop.org>
In-Reply-To: <49E4517B.4020301@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> (I wonder if its a bunch of super-secret HDMI crypto keys ;)
> 

It's too long to be an EDID block (128 bytes), but it could be part of it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

