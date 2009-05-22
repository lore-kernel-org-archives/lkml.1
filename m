Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZEVUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZEVUjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZEVUjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:39:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbZEVUjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jwBgbwzTyzDornhcQU7anjUedYHSjLZk0u0+eJsPpXCklhTQtCCNeuPS6szRkdnSTS
         A/Ye1ef3T655/EUE69ZDuxpgNVimeFeJ2gRdNzLs6NvFZjChsu7suuQxS+YBIWZzMZ1J
         ht8w8UrMfOvEioS5EyIZ7spNqAMdRzrujDbtE=
Date: Sat, 23 May 2009 00:30:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86,APIC: Detect lapic_is_integrated() once - use on
	and on.
Message-ID: <20090522203014.GH5354@lenovo>
References: <b9df5fa10905220631y7b1a094dn9a6e13de1b9c43af@mail.gmail.com> <20090522200239.GD5354@lenovo> <4A170713.402@zytor.com> <20090522202154.GG5354@lenovo> <4A1709D9.4070300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1709D9.4070300@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, May 22, 2009 at 01:23:53PM -0700]
| Cyrill Gorcunov wrote:
| > 
| > It was about a half year ago (need googling to be precise :)
| > but I was reported about Xeon processor which identify itself
| > as having "external" apic. So I hardly believe if real external
| > device with ICC bus were used.
| >  
| 
| Details, please.  It might even be a bug in the test.
| 
| 	-hpa
| 

yes, I'm trying to find it. wait a bit.

	-- Cyrill
