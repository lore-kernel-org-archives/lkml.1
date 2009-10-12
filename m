Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbZJLX7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbZJLX7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbZJLX7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:59:47 -0400
Received: from radagast.issp.eu ([86.59.99.45]:49885 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbZJLX7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:59:47 -0400
Message-ID: <20091013015909.14715ysuzihp51c0@www.kundendienste.net>
Date: Tue, 13 Oct 2009 01:59:09 +0200
From: Mathias Kub <lkml@makubi.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: arndbergmann@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
 <4AD3B1A6.10508@zytor.com>
 <20091013005346.95254r0nd1pw97s4@www.kundendienste.net>
 <4AD3BF8F.80709@zytor.com>
In-Reply-To: <4AD3BF8F.80709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, thank you very much, both of you.

Sincerely Mathias Kub

> On 10/12/2009 03:53 PM, lkml@makubi.at wrote:
>>
>> So iptables uses the in-kernel IP stack and because of that fact, it
>> is not able to filter the DHCP packets?
>>
>
> iptables is part of the in-kernel IP stack, yes...
>
> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


