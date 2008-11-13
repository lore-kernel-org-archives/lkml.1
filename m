Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYKMX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYKMX2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbYKMX2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:28:39 -0500
Received: from ag-out-0708.google.com ([72.14.246.250]:57330 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKMX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qytDwU9OtZdXlI+fBwIBYhlEuiQW7eoAM9VSQPknaW958/b3gcEIvYOgn9n7Xs9NTe
         bfSQDgMf+Tc6kgb5Zb+ajp2/cn2OXS/f97CZ5+4Bkaj+UybrXo6oi7myRTlVXJ0SNkcJ
         ekmTVeS0GOIwN7tpihNtw6gIqv3kD2O5Glhkg=
Message-ID: <c62985530811131528y66067065jb7a767a9057a1461@mail.gmail.com>
Date: Fri, 14 Nov 2008 00:28:36 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH][RESEND] tracing: fix a build error on alpha
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b6fcc0a0811131452x6531f52dg79845c9f6da1c561@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4906D0AE.7020903@gmail.com>
	 <b6fcc0a0811131452x6531f52dg79845c9f6da1c561@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Alexey Dobriyan <adobriyan@gmail.com>:
> On Tue, Oct 28, 2008 at 11:43 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
>> +#include <linux/irqflags.h>
>
> Already fixed.
>

And you were even put on Reported-by tag...
