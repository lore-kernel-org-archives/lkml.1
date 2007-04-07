Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXDGR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXDGR5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXDGR5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:57:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:5221 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbXDGR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AilU3EZ7WeWoZ+iGbeF/JBjlsyAmIWnqHi9sUjLB3WVCSZAM0nNvFIEA8qmxhKI9J/THGPOxuN3wIfv4uWIBten8cr0UUvU7OVYqNrUOYTgOIVas3P5IlnDVO49VdMVDcaX+H3QvEALT5cKYOsCDKBdJJMdH6ncRxbuh8ki0WcA=
Message-ID: <8d158e1f0704071057k515d4cc3yc1d444f63da6b577@mail.gmail.com>
Date: Sat, 7 Apr 2007 19:57:18 +0200
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, netfilter@lists.netfilter.org
Subject: Re: [PATCH] ip_tables.h
In-Reply-To: <8d158e1f0704071043w5483f60ayc9f240abb1039392@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0704071043w5483f60ayc9f240abb1039392@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Hi lads,

Oh! And! I don't want to take credit for things I didn't write, which
is this exactly.
I merely got the ip_tables.h header from 2.6.20 and filtered out what
I needed to get things work.
So, the actual credit for the code in the patch goes to the person who
put it in ip_tables.h under 2.6.20.

So whoever you are, thanks :)
