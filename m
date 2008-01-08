Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYAHAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYAHAtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYAHAtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:49:07 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:31793 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYAHAtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YpdOejZe3dBQqCFvfBT/Zz8HradErZ/7ikFJRinJQmMMioSl6sjc9IWHHpHxk/EANEKdxg5J6fZLCVuJ9VFKKhwumztLC1ujwgc7wP96ikV3aKlUbwCgQTCsTlO9/rPXYvTRUsSeodA7OFdfCWvihL2KXkB9a0QAjNs4jI5pHVc=
Message-ID: <82e4877d0801071649vd0af3a0h7cb7cbd0b58353ed@mail.gmail.com>
Date: Mon, 7 Jan 2008 19:49:03 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200801080054.57916.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801052042.56042.rjw@sisk.pl> <200801062011.31491.rjw@sisk.pl>
	 <82e4877d0801071521s607491f1ue25c4b97de47db71@mail.gmail.com>
	 <200801080054.57916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 6:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Well, now you're saying 2.6.23.12 is also affected, so this doesn't seem to
> be a recent regression in fact?
>

I have run 2.6.23 series before but my usage pattern seems to have not
triggered the bug before.
But yes, this is a 6 month old regression based on today's findings.
(2.6.22 which doesn't have this issue was released on July 8).

Parag
