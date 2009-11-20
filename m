Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZKTTSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZKTTSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZKTTSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:18:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51315 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZKTTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LfwA8V8/G0ML0O4zadFiFPySvlQspVqx/oR79ji+3nipS3sM+17KJXB7YAdzSm+93B
         amYjHYC0wjlyzqT3oHFa+P/FlVS6yVfpYqry+Uz52SNSRhPTZ+zwGh25lo869UJYa3sW
         fXX0iCG2uvBb+5PKs5X/e3DIQ9HcP+OWKS2p4=
MIME-Version: 1.0
In-Reply-To: <20091119193447.GA29091@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
	 <20091106224728.GA32205@kroah.com>
	 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
	 <20091107000749.GA26070@kroah.com>
	 <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
	 <a4c8a6d00911061745s4508d997v684683a1dbad821d@mail.gmail.com>
	 <20091119193447.GA29091@kroah.com>
Date: Fri, 20 Nov 2009 17:18:09 -0200
Message-ID: <a4c8a6d00911201118n7607b0f8nf56f7af1e071afb6@mail.gmail.com>
Subject: Re: [PATCH v2] staging/otus: trivial, fix sparse warnig.
From: Thiago Farina <tfransosi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Nov 19, 2009 at 5:34 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 06, 2009 at 11:45:05PM -0200, Thiago Farina wrote:
>> *apdbg.c: use NULL pointer instead of 0 integer.
>>
>> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
>
> Still doesn't apply, I don't know what you are doing wrong here :(
>
> odd.

How are you applying it?

I can try reproduce here and figure out what is wrong :/
