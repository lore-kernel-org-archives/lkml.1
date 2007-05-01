Return-Path: <linux-kernel-owner+w=401wt.eu-S1422941AbXEAAH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422941AbXEAAH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422982AbXEAAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:07:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:63923 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422941AbXEAAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ifTR5lQG/OxTdN80z1upUxuiWNLTJYKuLtPJUN1BtSppw1jNfy09/40hurF+IHWqFHQkaaj8FNv6Gfi+PyulJ7MfTYAi20eP84iyanMKXNISztNkjElNlDksdVEXe4hcnHJLu/Nn+SOTzFULj15ljiAy8Bt9pPD82qh8nvb2sGk=
Message-ID: <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>
Date: Tue, 1 May 2007 02:07:52 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
Cc: "Daniel Walker" <dwalker@mvista.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <463683A6.4010505@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
> Daniel Walker wrote:
> >
> > Hmm, Do you have a boot log ? I didn't see one in any of the last emails.
>
> When it doesn't boot, there's no log.
>
> When it does boot with the modified .config file,
> the log looks like the one attached to this email.

Please read chapter 3 {serial,net}console
http://www.stardust.webpages.pl/files/handbook/handbook-en.pdf

>
> Cheers
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
