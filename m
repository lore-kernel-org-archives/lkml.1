Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbYJRJyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbYJRJyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 05:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYJRJyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 05:54:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:39091 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYJRJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 05:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Hpu4HWKzIP6JCmozFdUxYRoOst0LD48WrDogcXSOFqU7E+8mPrRRZ6zg+imfb3a0FI
         BNkV4KAAKRS6GXE8grrUGkxFA/E81xECKgvKZ10rdIJTA4EFIHXGmhdrxrsnkaqIgyax
         Hs8LdR/38XuHcvT6AKEg32SHIAqDHcyCb5+C0=
Message-ID: <84144f020810180254u6fa1c3b9t987f06ccd204a81a@mail.gmail.com>
Date: Sat, 18 Oct 2008 12:54:39 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Fred ." <eldmannen@gmail.com>
Subject: Re: Stop accept/merge code that does not compile without warnings
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f188924b0810171815rf486248s9ad1e3f968f907a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f188924b0810171815rf486248s9ad1e3f968f907a1@mail.gmail.com>
X-Google-Sender-Auth: 2a4509388ba986c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fred,

On Sat, Oct 18, 2008 at 4:15 AM, Fred . <eldmannen@gmail.com> wrote:
> Kernel development is supposed to be done by professionals.
> Please stop merge code that does not compile without warnings.
> If when you compile it, if it does spit out warnings, then reject it!
>
> We need professional quality, we cant merge any crap, else we get
> unstable kernel with lots of bugs.
> Kernel developers are supposed to be expert programmers, they
> shouldn't have code that spits out warnings.

Thanks for the excellent advice! I'm sure we'll all be more careful in
the future knowing you're looking after us.

Keep up the good work.

                   Pekka
