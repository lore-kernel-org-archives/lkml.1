Return-Path: <linux-kernel-owner+w=401wt.eu-S965150AbXCAPBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150AbXCAPBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXCAPBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:01:09 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:8494 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965150AbXCAPBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SqBVFeZ63oKVZoAaSXa7mBu22MD3kJ9otDK9EYrbpmXqQYjG+34oohj52oMefvdNClUZ5PbyyEbVJT4uBd2e+jeEq2M8qr8uR8PGLC/o4mgaidFxKDR+Bo0xLEH/mnRqCTaxp1l66Dtvh1hj5ui7htEiQa+5OUVKdvp8szLIbE8=
Message-ID: <d120d5000703010701y44ba3cfcxf58e1897fe47a4d6@mail.gmail.com>
Date: Thu, 1 Mar 2007 10:01:02 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?Kristian_Gr=F8nfeldt_S=F8rensen?=" <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1172760952.21416.110.camel@miraculinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl>
	 <200703010036.28166.dtor@insightbb.com>
	 <1172760952.21416.110.camel@miraculinux>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> On Thu, 2007-03-01 at 00:36 -0500, Dmitry Torokhov wrote:
> >
> > Please try the patch below.
>
> Hmmm. Is the diff against 2.6.20? All hunks except one fails when i try
> it. If I pass "-F 3" to patch, then one more hunk succeeds. Am I doing
> something wrong?
>

Hm, technically speaking it is against 2.6.21-rc2 but I think exceppt
for tsdev part it should apply to 2.6.20...

-- 
Dmitry
