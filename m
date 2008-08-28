Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYH1U7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYH1U7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYH1U72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:59:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:20013 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbYH1U70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UzrgsfuVJaz+6Di+dX+cwTh00fkWb1LNC+Lw6N40gSTKFLF+mH21oaJL3ZuP3VuEhI
         snbiJ0cSt01CWNFn+4RAKKmIMTw0z135hv8X/PShAKhnC4zUy64s0jwS2f1CrkdR35dG
         HY+Mjn1ME/IFg6I3sQsg8KPgykL/qJ1pvdUZE=
Message-ID: <86802c440808281359t35e0e809i50143b7f8a4bdf84@mail.gmail.com>
Date: Thu, 28 Aug 2008 13:59:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jari Aalto" <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87bpzcj26b.fsf_-_@jondo.cante.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.c8YPWdZHXAabbZwTVLAgq9ahOlE@ifi.uio.no>
	 <fa.9B7J3O7801PlFtm4WwuBX/J0kU8@ifi.uio.no>
	 <fa.ES0QYHe349FfrOTaqTun1n3qaYk@ifi.uio.no>
	 <fa.8FK+C3lDiXBnZCV9FTofTkm6PJE@ifi.uio.no>
	 <fa.cN6j0N4TRlTlG7oLEhhT8Wj2N7A@ifi.uio.no>
	 <fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no> <48B1D82C.5000107@shaw.ca>
	 <87d4jyys7y.fsf@jondo.cante.net> <m3hc9akkt9.fsf@maximus.localdomain>
	 <87bpzcj26b.fsf_-_@jondo.cante.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 1:49 PM, Jari Aalto <jari.aalto@cante.net> wrote:
> Krzysztof Halasa <khc@pm.waw.pl> writes:
>
>> Jari Aalto <jari.aalto@cante.net> writes:
>>
>>> What, if after booting to 2.6.26 and without any 'iommu' boot parameters,
>>> there still appears "Out of Iommu space" messages? What kind of logs
>>> should I post?
>>
>> You shouldn't be getting "Out of SW-IOMMU space" messages when not
>> using SW-IOMMU.
>
> REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread start)
>
> I regret to report that:
>
> - Upgraded to kernel 2.6.26-1-amd64 (Debian/unstable 2.6.26-3)

can you send out whole boot log? with "debug initcall_debug"

http://people.redhat.com/mingo/tip.git/readme.txt

YH
