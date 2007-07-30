Return-Path: <linux-kernel-owner+w=401wt.eu-S939990AbXG3Wgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939990AbXG3Wgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXG3Wgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:36:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:41073 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXG3Wgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:36:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C26xhyF8d41qDt8OkLcIlVIPHOwdgJGgs3CBZwIAqywC3Eth40ZRfFzRkCt3HDLenhMU3GtHvh7MPNsHZmZ/Q1mUs84y6XiwFvXiyBIFEIewSNar0Ujp9aAyUkawTQeDxb3my44L+oJA7yx0n4xnjqZwPuFVahL0Qkv2EwLRRxo=
Message-ID: <6bffcb0e0707301536s40961661r11ed8239c85a16f2@mail.gmail.com>
Date: Tue, 31 Jul 2007 00:36:44 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adam Kropelin" <akropel1@rochester.rr.com>
Subject: Re: [1/3] 2.6.23-rc1: known regressions with patches v3
Cc: LKML <linux-kernel@vger.kernel.org>, "Greg KH" <gregkh@suse.de>
In-Reply-To: <20070730191322.GA24512@mail.kroptech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46AE1304.80408@googlemail.com>
	 <20070730191322.GA24512@mail.kroptech.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On 30/07/07, Adam Kropelin <akropel1@rochester.rr.com> wrote:
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > Here is a list of some known regressions in 2.6.23-rc1
> > with patches available.
>
> I don't know which list this belongs in (good: 2.6.20.6, bad 2.6.22.1),
> but here's a clear regression with patch:
>
> Subject         : Edgeport UPS Monitoring Problems
> References      : http://lkml.org/lkml/2007/7/27/334
> Last known good : 2.6.20.6
> Submitter       : Nick Pasich <NewsLetters@NickAndBarb.net>
> Caused-By       :
> Handled-By      : Adam Kropelin <akropel1@rochester.rr.com>
> Patch           : http://lkml.org/lkml/2007/7/29/164
> Status          : patch available

Please send this patch to Greg.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
