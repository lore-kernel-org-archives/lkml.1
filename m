Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbXEFKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbXEFKNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 06:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbXEFKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 06:13:35 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:40752 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570AbXEFKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 06:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nruCjll/nZWtezNP16XNDe0LgvWqA+WtSLFvImXFoCSvNfDm8TPSQrmaxfwCTpzp96tmIlJHOiRG0drRGQE13em0fsQpcdoeEBzlIvw7A8nqLlvzBi88DdaAood/VVSkYPB2ox5WjbinLTLmIXCLzq/JSLrsuTUeUCFjr0SG4TA=
Message-ID: <5486cca80705060313o65bff1a8v3fd9532361b2a90b@mail.gmail.com>
Date: Sun, 6 May 2007 12:13:33 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: swap-prefetch: 2.6.22 -mm merge plans
Cc: "Ingo Molnar" <mingo@elte.hu>, "ck list" <ck@vds.kolivas.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <200705051842.32328.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <20070504085201.GA24666@elte.hu>
	 <200705042210.15953.kernel@kolivas.org>
	 <200705051842.32328.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Con Kolivas <kernel@kolivas.org>:
[cut]
> Here's a better swap prefetch tester. Instructions in file.

The system should be leaved totally inactive for the test duration (10m) right?


Regards,

  ~ Antonio
