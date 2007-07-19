Return-Path: <linux-kernel-owner+w=401wt.eu-S965433AbXGSRAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433AbXGSRAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965138AbXGSRA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:00:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:63430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965096AbXGSRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sZB613JcdlUAXZ0GC7NbVHm65P1ycwYsKYd+zUlDi8KXlET00wPd/YLnVk3/j5quoUj5zQ6M5OTqdwFoXxgkU2h/WOo6AX7Cn9IHVKyuyzQvOol4pxjNb1G8i5VXxzFBX4kj9Wx/bFKwRY3RISx4niN1g0e9oA+jQkQWGG7hhTc=
Message-ID: <86802c440707191000w69026f1em991a4c4fce17301a@mail.gmail.com>
Date: Thu, 19 Jul 2007 10:00:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] [8/58] x86_64: Use string instruction memcpy/memset on AMD Fam10
Cc: "Andi Kleen" <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707191841220.31013@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191154.642492000@suse.de>
	 <20070719095452.4419E14E04@wotan.suse.de>
	 <Pine.LNX.4.64.0707191841220.31013@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jul 19 2007 11:54, Andi Kleen wrote:
>
> >Subject: [PATCH] [8/58] x86_64: Use string instruction memcpy/memset on AMD
> >    Fam10
>
> What processors carry 0x10?

Quad core Opteron.

YH
