Return-Path: <linux-kernel-owner+w=401wt.eu-S964858AbXHHCqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbXHHCqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXHHCqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:46:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:51929 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbXHHCqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BvZSeHMgVDZ+IHinb9X9W401swL69tq4p/E9HvxA38jnwdNzw6oVyFST36c1gtaia7PoZQbokIlPOCygk6RuZfh8LT695F6fm1HsVJDMBxihK21fM3pwPSZ2wpi8kPHW1aaYRz8m9Gs4LnDp46S8iDvB6LUW8sVwbf3SA58zC7w=
Message-ID: <b6a2187b0708071946v79008703te82d57ea8ef7d9bd@mail.gmail.com>
Date: Wed, 8 Aug 2007 10:46:35 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Linux 2.6.23-rc2
In-Reply-To: <20070807170513.GF20404@vasa.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
	 <46B4C011.8090802@zytor.com>
	 <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com>
	 <46B53FDF.5020806@zytor.com>
	 <b6a2187b0708050452m1b1b5c5ck163f64a26686d3cc@mail.gmail.com>
	 <20070807170513.GF20404@vasa.acc.umu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, David Weinehall <tao@kernel.org> wrote:

> Try adding acpi_sleep=s3_bios to your kernel boot options and see if it
> helps.

I tried, but that didn't help.

Thanks,
Jeff.
