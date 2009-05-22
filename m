Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZEVSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZEVSc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZEVScW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 14:32:22 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:44050 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbZEVScV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 14:32:21 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 14:32:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=dX+HrkvjODzcEvmZytpqr+w46IRlJ4lu9glb2AXb82YAo2QeYOvW3CVIoujHZ4S891
         BjIyuv2NbZ7orAARk+RNqtnb9F5ZJ4WMTo2duj/X1gPXp1rIWJajH6i/Ev0NmJrtYn87
         lR1B6X7yqmcsrgotvlZGCP89gqnYQB2OrjTpE=
Date: Fri, 22 May 2009 20:24:02 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Pavel Machek <pavel@ucw.cz>, Peter Feuerer <peter@piie.net>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Contro
Message-ID: <20090522182402.GA23618@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Andreas Mohr <andi@lisas.de>, Pavel Machek <pavel@ucw.cz>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20090522140930.GA26580@elf.ucw.cz> <20090522161009.GA20476@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090522161009.GA20476@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 06:10:09PM +0200, Andreas Mohr wrote:
> Hi,
> 
> > Yep, I don't disagree. But I strongly suspect that if you force the
> > fan off and overheat the machine, it will shut down in hardware before
> > doing any damage.
> 
> s/strongly suspect/definitely know/ ;-)
> 
> Reason being that my machine suddenly dropped dead (2 or 3 times maybe),
> and when I then reactivated it, the fan made a nice tick....tick....tick noise
> as if it tried to start but something blocked it a bit too much.
> Shook and rocked the box a bit (not too difficult with a netbook after all ;),
> then it worked again and ever since.
> Probably a slightly wonky fan, but I'm not sure whether I should care
> all that much at the moment.

:).

> I _am_ using the shell script currently, but within pretty safe limits
> (I'd hope that I'm not insane after all), thus I don't think this negatively
> affected fan health or machine.

What are your settings now?

-- 
Regards/Gruss,
    Boris.
