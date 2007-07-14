Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbXGNSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbXGNSa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbXGNSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:30:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:45906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479AbXGNSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FVF8bbwjdWX3+uAB07utLGHugsPfnirY0s4MObXVSHY6X6wRsrrWS0fYqWzTCtE10cBmqAThbzzARIBhbnXAtWF1nMV/BmdC23dzZH3YzfwgBSZx1AZxwlJWmv2+Te7hGonJdKvxt7OtqZCx0DdRcgfjytyK1Rs03nS91TRGYXk=
Message-ID: <46991616.8070509@googlemail.com>
Date: Sat, 14 Jul 2007 20:29:42 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org
Subject: Re: [PATCH] NET_CLS_RSVP6 should depend on IPV6
References: <4698A7B6.1030302@googlemail.com> <4698ED6E.6020502@trash.net>
In-Reply-To: <4698ED6E.6020502@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Gabriel C wrote:
>   
>> cls_rsvp6 only works with IPV6 enabled kernels and IMO it should depends
>> on IPV6.
>>     
>
>
> I can't see any functional dependency on IPv6, what exactly are you
> refering to? People might want to use it on a bridge for example
> without having IPv6 running locally.
>
>   

I didn't knew it can be used with bridges , in this case just ignore the
patch and sorry for the noise.


Regards,

Gabriel
