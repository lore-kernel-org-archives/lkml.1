Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZBEQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZBEQZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZBEQZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:25:10 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:63322 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbZBEQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n2d3IncTbiXVJZpSx26XSqyBnuRl8WorXOkWWfa7PnXidzU4O1o3Z3kV64kt492qb9
         iIBXddofZlCWvFaNw72W9bRUNHInmp6cUVnj8PUnzbAqKwv9YWwJ40WvTV6iFmdYiBTS
         KKJIXwGFbeHyB/M51NtpYvKqA0Kyn7jq/2ayE=
MIME-Version: 1.0
In-Reply-To: <200902051709.12967.rjw@sisk.pl>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
	 <CGyEB0S4BpO.A.C8C.-5YiJB@chimera>
	 <a5d587fb0902041844v40f1d441s535d070437aa9823@mail.gmail.com>
	 <200902051709.12967.rjw@sisk.pl>
Date: Thu, 5 Feb 2009 08:25:05 -0800
Message-ID: <2c0942db0902050825q90be8d3uf16cafa2e24115bd@mail.gmail.com>
Subject: Re: [Bug #12393] debugging in dosemu causes lots of 'scheduling while 
	atomic'
From: Ray Lee <madrabbit@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Suchanek <hramrach@centrum.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 8:09 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 05 February 2009, Michal Suchanek wrote:
>> As I said earlier I have received a patch that I applied locally and
>> that fixes the problem.
>>
>> As to if and when the patch actually appears in the kernel is out of
>> my control, and nobody told me that it was applied.
>>
>> If you believe it was applied to a kernel version that is readily
>> available for download I am wiling to test such version.
>
> I don't at the moment.
>
> Can you send me a URL to the patch, please?

http://lkml.org/lkml/2009/1/13/445
