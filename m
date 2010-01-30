Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348Ab0A3PrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0A3PrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289Ab0A3PrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:47:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44680 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0A3PrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:47:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vfYeB1qRvUCOHFSEp5h2RPX2Mur3M76F2nNVlK9Wvv3sWQSovZf3FtWye2aBreDk1c
         HMElREufqokQvU5Jegixy4ci/x/2K6sv8Bjq3gExtpd/CZnV0TQrCu64cE805bqBVHuM
         KzWwT+A+3Q4L5+VLm/OyWOlVGVyaD65H93Fas=
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was:
 Re: [linux-pm] Memory allocations in .suspend became very unreliable)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <201001170138.37283.rjw@sisk.pl>
References: <1263549544.3112.10.camel@maxim-laptop>
	 <1263678289.4276.4.camel@maxim-laptop> <201001162317.39940.rjw@sisk.pl>
	 <201001170138.37283.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 17:46:59 +0200
Message-ID: <1264866419.27933.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-17 at 01:38 +0100, Rafael J. Wysocki wrote: 
> Hi,
> 
> I thing the snippet below is a good summary of what this is about.

Any progress on that?

Best regards,
Maxim Levitsky

