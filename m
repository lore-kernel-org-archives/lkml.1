Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZFCNPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZFCNPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZFCNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:15:05 -0400
Received: from mail-ew0-f162.google.com ([209.85.219.162]:63708 "EHLO
	mail-ew0-f162.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZFCNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XtUBg1SR8aQXB8jQfMgCAMhGlDTp8/FrWOtfDdUFF/Mq40BBCqVoFIUqHmtiV/BP13
         Yrx/MdUhegMOBgjM1vq3Enqs+VsMrk3wZV48a/vDUb/ME94/Fulp+FjM4qCTOL3GSj3E
         MniNJg2jX7eRT1D5Ka/f89mPhQ3AXMi+g88Rg=
MIME-Version: 1.0
In-Reply-To: <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <4A25F688.9000407@gmail.com>
	 <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	 <20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
Date: Wed, 3 Jun 2009 15:15:04 +0200
Message-ID: <c5bd819b0906030615t67e20299q38e81992419637fa@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/3 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> What about 2.6.28 or 2.6.29 ?
>

Hi,

I did not try those and I don't think I can find them anymore in the
build service. There's only a 2.6.29 realtime one. I will try it out
and report back in a few...
