Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZFCOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZFCOtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZFCOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:49:32 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38898 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZFCOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z+/ehttcXFzZwZ5kjoMyqrtndF09aWPMpVGp3ZcaLoMY9h4gggRWnHamaQEqaOKtvu
         diCJ4Fzg1AMnJeX7tOEU2IgdKUNGmr143ZPC7WfH5/wbPCeF9aedoJ8P/xvBmctslaVJ
         T9pb2KHj3+0s4beHCQSn9o9nljM8NP/yo4tcA=
MIME-Version: 1.0
In-Reply-To: <cone.1244034452.652744.16292.1000@arca>
References: <1240950704.3781.12.camel@maxim-laptop>
	 <cone.1242065107.695268.13534.1000@onepiie>
	 <20090512060231.GB26286@liondog.tnic>
	 <cone.1242669880.118150.4276.1000@deskpiie>
	 <20090524192219.GA30285@liondog.tnic>
	 <cone.1243865541.882421.4368.1000@deskpiie>
	 <20090603073552.GA2671@liondog.tnic>
	 <cone.1244016635.374757.16292.1000@arca>
	 <9ea470500906030352x7d72f3c7s94b12701142a7f7a@mail.gmail.com>
	 <cone.1244034452.652744.16292.1000@arca>
Date: Wed, 3 Jun 2009 16:49:31 +0200
Message-ID: <9ea470500906030749q173dc090j5fac82b92f02f4a3@mail.gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 3, 2009 at 3:07 PM, Peter Feuerer <peter@piie.net> wrote:
> I fixed the resume / suspend issue and re-enabled userspace control.
> Can you please also have a look if this time the patch isn't line wrapped
> for you? - I saved the patch from my last submit and applied it, it's
> working. I also downloaded the diff from http://lkml.org/lkml/2009/6/3/117
> and it's working too.

Unfortunately it is still line-wrapped. Your mailer is sending
format=flowed mails:

Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline

which can cause unexpected line breaks.

The diff at http://lkml.org/lkml/diff/2009/6/3/211/1 applies cleanly,
though.

-- 
Regards/Gruss,
Boris
