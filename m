Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYFTSfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYFTSfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYFTSff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:35:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51595 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYFTSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:35:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JJ1oL06aqRm6BdKFgjgBTFVzpfulZgUZA/04jByk2dIFeMjUxy9CYkolPqnHMFGrZ
	CMm1kiYtQXxxoeVD6z/YQ==
Message-ID: <da824cf30806201135y7235df5cocd1dfe30d9cae54a@mail.gmail.com>
Date: Fri, 20 Jun 2008 11:35:20 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] IDE fixes
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080620190948.537f7f7a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806202007.38081.bzolnier@gmail.com>
	 <20080620190948.537f7f7a@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 11:09 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>> +     PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b632),
>
> That one seems to be a digit short - is it 0x0f68b632 or a typo ?

Typo. Original patch seems to have 0xf68b6f32

http://lists.infradead.org/pipermail/linux-pcmcia/2008-May/005496.html

grant


>
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
