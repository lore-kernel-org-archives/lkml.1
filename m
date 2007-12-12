Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXLLQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXLLQh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbXLLQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:37:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:40001 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbXLLQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:37:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pMfXyW2QsgCtK6WoXmbhMhUP2ns6teYTxe474RGfo1XrPkAoEZ5etAohLo2WITmXbqq2R57snji3FinQ38rwQgHO639Szw2QPYjJyGD7JKTbZAg1QIv44vt9NHB2FAYqC4uIY75tJ0+ib1LZxM2ad0U0ut9pVYQp1ZqIAttCJK8=
Message-ID: <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com>
Date: Wed, 12 Dec 2007 11:37:16 -0500
From: Shane <gnome42@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: 2.6.24-rc5 "videobuf_read_start" [drivers/media/video/videobuf-dvb.ko] undefined!
Cc: "Adrian Bunk" <bunk@kernel.org>, "Brandon Philips" <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <1197469316.4744.22.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com>
	 <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota>
	 <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 9:21 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
...
> The proper solution is provided by this changeset:
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc

I applied this and it seems fine with a bttv card.

Mauro and Adrian,

Thanks for your prompt attention to this and for promptly pushing the
fix to Linus.

Regards,

Shane
