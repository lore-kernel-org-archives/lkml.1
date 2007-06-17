Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXFQPb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXFQPb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXFQPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:31:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:1824 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXFQPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R7wyAhGKhfuqeEm8jbaGp4mQ5KxltcFyfHtCKtCSKSnoxn+CtphyXKIaqWe61Pq1FCCCVa9ksPmjsggGDN4ph/o/ZHoXFamzC7Q/rLFYtGamAZiQJe32Ahg++r0KHPGfyG9VRwM2oeD+jo9fAq4dmu+Lv4uJQ4ijAwNMH0eQLWg=
Message-ID: <6bffcb0e0706170831p80b4722qe03856a030c4c8ee@mail.gmail.com>
Date: Sun, 17 Jun 2007 17:31:17 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>,
       "Darrick J. Wong" <djwong@us.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Bj?rn Steinbrink" <B.Steinbrink@gmx.de>,
       "Ian McDonald" <ian.mcdonald@jandi.co.nz>,
       "William Cohen" <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       "Antonino Daplas" <adaplas@gmail.com>, "Olaf Hering" <olaf@aepfle.de>,
       "Ville Syrj?l?" <syrjala@sci.fi>, "Jean Delvare" <khali@linux-fr.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Soeren Sonnenburg" <kernel@nn7.de>
In-Reply-To: <20070617151612.GB11762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467543FA.60905@googlemail.com> <20070617151612.GB11762@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Subject    : long freezes on thinkpad t60
> > References : http://lkml.org/lkml/2007/5/24/100
> > Submitter  : Miklos Szeredi <miklos@szeredi.hu>
> > Handled-By : Ingo Molnar <mingo@elte.hu>
> > Patch      : http://lkml.org/lkml/2007/6/16/81
> > Status     : patch was suggested
>
> i think this isnt a new regression in .22, it existed in .21 too - or
> are you tracking all 2.6 regressions?

Unfortunately I don't have enough time, will and tools to track all
2.6 regressions.

Anyway, I'll leave it on the list. We've got a fix :)

>
>         Ingo
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
