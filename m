Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZKPEZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZKPEZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZKPEZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:25:43 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46764 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZKPEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JPRJlKjj5/HjdACSzQfcdRc9Sk6LSoQOpMGX8pnKhIkjSi2HSeYSJMKp2B5e+TCr7E
         pa6cFct4iesWYsGk3xlinf/8/zf7Ih3uMswQBHvRnIhI80uW+iFgOOdkfYJ/hPuSu2vY
         B9SafSrOM94CTDq93ld8SOIeYffKO7qwFGLIs=
MIME-Version: 1.0
In-Reply-To: <1258339401.2003.3.camel@violet>
References: <4fb5db50911121909h1619e483ga4aa395af8fc1161@mail.gmail.com>
	 <1258082571.7715.13.camel@violet>
	 <4fb5db50911140519q70bbdd00qb585153c4926df96@mail.gmail.com>
	 <1258216474.3299.24.camel@violet>
	 <4fb5db50911140937j278584e5nf9e4d5767a44a920@mail.gmail.com>
	 <1258221909.3299.26.camel@violet>
	 <4fb5db50911151836u5b4844adrd91b56a5ebc7084d@mail.gmail.com>
	 <1258339401.2003.3.camel@violet>
Date: Mon, 16 Nov 2009 09:55:46 +0530
Message-ID: <4fb5db50911152025j20eba2e6xf243d6af57f81ed1@mail.gmail.com>
Subject: Re: [PATCH 1/1] Adding radio type FM
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

I am sorry about this.There is a problem with my git send-email.so i
had to use the mailer.I will surely take complete precaution that it
will not repeat further.

Regards,
Ram.

On 11/16/09, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Janakiram,
>
> so first of all, please stop sending emails to majordomo. That is not a
> real person.
>
> > Adding changes  RFKILL type FM  and for RFKILL for FM  in core
> >
> > From 4bf0ae6c90de9a766914abeb5ab5e5428089b648 Mon Sep 17 00:00:00 2001
> > From: Janakiram Sistla <janakiram.sistla@gmail.com>
> > Date: Mon, 16 Nov 2009 07:58:09 +0530
> > Subject: [PATCH 1/1] Adding radio type FM
> >
> > Adding radio type FM in RFKILL_TYPE_.FM belongs to
> > same class of with both TX/RX capability.
> >
> > Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
>
> the patch itself is fine, but can we get at least one with a proper
> commit message. And if you mailer is broken, then either fix it or use
> git send-email.
>
> Regards
>
> Marcel
>
>
>
