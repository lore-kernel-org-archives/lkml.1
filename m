Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYDIHHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYDIHHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYDIHH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:07:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:52225 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYDIHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KZpHypYyRfHnLdMph1bxk/2lNzYpBVXDy0OhxlAugKAMlLkbCMbis9o1M/QoaaSyyM9qEFnCos6m1TRBVjpib4EkPR4dtWm2WcgtuPl4sqVVGYs+4ZTzHUOZNsgwchHkxxOxnAfDNW+sZ8Z7THbuWWKCfg2v5rDny28CZeC6QmU=
Message-ID: <29495f1d0804090007u17b0524cwe154434d62531083@mail.gmail.com>
Date: Wed, 9 Apr 2008 00:07:25 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10082] 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>
In-Reply-To: <SvnMeM-aZi.A.E8F.BCA_HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <SvnMeM-aZi.A.E8F.BCA_HB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
>  of recent regressions.
>
>  The following bug entry is on the current list of known regressions
>  from 2.6.24.  Please verify if it still should be listed.

>From a separate thread and my own discussions with Kamalesh, I believe
this is not actually a regression in 2.6.25-rc*, as some 2.6.24-rc
kernel displayed the same problem. Unfortunately, it's a little tough
to automatically bisect as the oops happens intermittently. In the
other thread, though, Paul mentioned a patch which might fix the issue
was merged recently.

Kamalesh, any updates?

>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10082
>  Subject         : 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
>  Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>  Date            : 2008-02-20 16:01 (49 days old)
>  References      : http://lkml.org/lkml/2008/2/20/218
>                   http://lkml.org/lkml/2008/1/18/71
>  Handled-By      : Paul Mackerras <paulus@samba.org>

Thanks,
Nish
