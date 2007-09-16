Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXIPRDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXIPRDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXIPRDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:03:17 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:7124 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXIPRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D7aTY07Vw1b2T4qLeG6OV+klnAqQIJOeOovDjwdzqVyjSFMfpuKlQBRt7i9TJzXfUpxnUFbUDWCcR6NOTcUAnLCpxHU/8hr77Zeh7m5Si2RifPrNea61240rqW83dSjRMzZKS8Ff3dluh0fPaGCFQ0a9rTL/m9Buh9GaStDKwe0=
Message-ID: <8b67d60709161003y45acf119n2295914a4d8bdd0f@mail.gmail.com>
Date: Sun, 16 Sep 2007 18:03:14 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: SPARC{,64}: kernel_termios_to_user_termios_1 missing
Cc: "David Miller" <davem@davemloft.net>, vonbrand@inf.utfsm.cl,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070916004231.cf2df744.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709152137.l8FLbtXP001446@laptop13.inf.utfsm.cl>
	 <20070915.153602.74747413.davem@davemloft.net>
	 <20070916004231.cf2df744.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/2007, Andrew Morton <akpm@linux-foundation.org> wrote:

>
> Hopefully bb8bd3a52a5dbca8bea31bfc72dacfb384170e69 (merged six hours ago)
> will have fixed this.  It Works For Me.

It also works on SH4
