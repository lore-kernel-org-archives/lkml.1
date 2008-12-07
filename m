Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYLGNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYLGNgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYLGNg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:36:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:20888 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYLGNg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:36:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SV0AIjozFWIfAecAZEKJ11HIBcj5ZmkglH44CEr5z71v50Ex/6slt32oyFu/4L18xA
         YVsRbX9/UDU0bk8G3b11Y50UNJ3wjViyXuBV4kDQ6EjdEl6T2NnOkh+aYfm2f0AuffHY
         HQr71IyiM4GTnZIpybs5qWXYCFT9mIeXzNfN8=
Message-ID: <493BD14E.6020606@gmail.com>
Date: Sun, 07 Dec 2008 14:36:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Michael Tokarev <mjt@tls.msk.ru>, Mark McLoughlin <markmc@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <4938EE0B.8020501@msgid.tls.msk.ru> <493929D2.4070900@gmail.com> <200812071900.08987.rusty@rustcorp.com.au>
In-Reply-To: <200812071900.08987.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> Fix the virtio bus instead.
> 
> Incoherent? CHECK

Sorry, I don't undesratnd here. Incoherent with what?

> Rude to bug reporter? CHECK

Maybe it's my english. I apologize all, who understood my replies that way,
sorry for that, it was not intentional.

> Unhelpful? CHECK

I don't know, I expect people to ask for concrete implementation details, if
they don't know. Ok, pointing to the relevant documentation next time would
be better, I agree.
