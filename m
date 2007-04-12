Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXDLBLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXDLBLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030614AbXDLBLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:11:40 -0400
Received: from [202.78.101.198] ([202.78.101.198]:45532 "EHLO mail.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965397AbXDLBLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:11:39 -0400
Message-ID: <461D871B.6070901@gmail.com>
Date: Thu, 12 Apr 2007 09:10:51 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: JanuGerman <doublemalam@yahoo.co.uk>
Cc: linuxkernel <linux-kernel@vger.kernel.org>
Subject: Re: Security computation within Linux kernel
References: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com>
In-Reply-To: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

JanuGerman wrote:
> Hi every one,
> 
> I have one question regarding security libraries, already shipped with Linux Kernel. That is, all PKI, RSA libraries, as provided by OpenSSL are already integrated within the linux kernel source code? OR, one have to use OpenSSL seperately in this regard. 

IIRC, The kernel does some encryption functions, involving TCP, NFS, and 
IPsec since all these are part of the kernel itself.

If you intend to write your own apps that have to use encryption functions, 
it would be best to use the relevant encryption libraries, such as OpenSSL.

Thank you very much.

Best Regards,

Carlo


-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, Diliman 1101, Quezon City
Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
