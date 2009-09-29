Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZI2TW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZI2TW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 15:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZI2TW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 15:22:58 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:51722 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZI2TW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 15:22:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Oe0x98pe0uMrwA3qfR2Nj2cHzdxOsrFMYwTLkKKpe711J7FDYAjdXjMLdVHtLBIbAw
         JYn7/aOvsVDsvJa7RhJzuTNiq5gC2Cnr0xeoMF0CBWm4eVSiJ0iFLxWsydJasKQFbi/N
         5RjHXQ3x+sLuQhR4UFTlCvzULS43fHhEjq0zw=
MIME-Version: 1.0
In-Reply-To: <200909291932.17282.volkerarmin@googlemail.com>
References: <200908211814.56800.volkerarmin@googlemail.com>
	 <200909192211.12226.volkerarmin@googlemail.com>
	 <86802c440909192303j643d83b5te710926a99ddb2e5@mail.gmail.com>
	 <200909291932.17282.volkerarmin@googlemail.com>
Date: Tue, 29 Sep 2009 12:23:01 -0700
Message-ID: <86802c440909291223n717894e3xdcd5ad4cdc8a6d28@mail.gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and 
	earlier.
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 10:32 AM, Volker Armin Hemmann
<volkerarmin@googlemail.com> wrote:
> On Sonntag 20 September 2009, Yinghai Lu wrote:
>> your looks ok, because you got new CPU, and HW will set WB for [4G, TOM2)
>
> so the memory beyond 4gb is covered but the coverage is not shown in
> /proc/mtrr?

right.

YH
