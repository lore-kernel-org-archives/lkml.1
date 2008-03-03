Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYCCIHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYCCIHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYCCIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:06:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17972 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYCCIG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sDt1RjIw3B5d9iZKv7zL9riKzgmmjZmGWVun3iGaRkwSCihUd0cwXc9XBMIO8IYz4dkPBP7az024WVyCRmMCbuBFFvWOFvc1+sV4udvq2gOXBex1dvEqUYqTWhxB2I11Gdm3izYTkvConFBbvjjNr1oZDiH/AiojS+7UEbmYSVc=
Message-ID: <38b2ab8a0803030006m577304c1wcb57b32e62da6170@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:06:56 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200803022039.51634.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
	 <38b2ab8a0802280608v2a75812boc11c7672c2d356a6@mail.gmail.com>
	 <38b2ab8a0803010311v10b1537ehcef918f2c1f79912@mail.gmail.com>
	 <200803022039.51634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 8:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 1 of March 2008, Francis Moreau wrote:
>  > Ok,
>  >
>  > After spending (too much) time to bisect this, I found that the looser
>  > commit is:
>  >
>  > c31c7d4844ea4817692ae16bf70f9c96c05a50eb
>  > [ x86: CPA, fix alias checks ]
>
>  Please add yourself to the CC list of the Bugzilla entry at:
>  http://bugzilla.kernel.org/show_bug.cgi?id=10140
>

OK, done.

Thanks.
-- 
Francis
