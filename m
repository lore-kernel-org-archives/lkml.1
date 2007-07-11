Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbXGKIua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbXGKIua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXGKIuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:50:22 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:64258 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXGKIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sHiI5aNspBA3xzXiTC/PuzY1SXRZs//y0pm2n6ft+HDUAzYbcEreTJUEsqWUdbJ5OgLaLMnGTuOIe1VsMRQyHy4Dh9i7ZUOsyWknIOdEN3e13YqLX9y9BIcw/xzJa3SeWym3hpZQrvBcVfIP5f6XqeJlGn4EmGkS5dNDpqZj1MU=
Message-ID: <1a297b360707110150x56e8ad6cu64ab768e7d3ce6ed@mail.gmail.com>
Date: Wed, 11 Jul 2007 12:50:20 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Nobin Mathew" <nobin.mathew@gmail.com>
Subject: Re: Reading a physical memory location
Cc: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <8d6898730707110114p3c02e24as8ca8359731fdc320@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
	 <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
	 <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>
	 <1a297b360707110111u25a786c5m4857673e3e1b90a1@mail.gmail.com>
	 <8d6898730707110114p3c02e24as8ca8359731fdc320@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> See this in the documentation
>
> The returned virtual address is a current CPU mapping for the memory
> address given. It is only valid to use this function on addresses that
> have a kernel mapping
>
> This function does not handle bus mappings for DMA transfers. In
> almost all conceivable cases a device driver should not be using this
> function
>

To get a better idea, look here
http://tldp.org/LDP/khg/HyperNews/get/devices/addrxlate.html
