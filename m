Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXD0Uqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXD0Uqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXD0Uqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:46:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:11798 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbXD0Uqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CjVZioNQFdbVynb5y0untyTkgS10b1ZzCMLKTqj8QObUzPPFYfBxGVExprIx6xL0KC0ReAxjgDJDynIaUTzfpksdJ5UVCHABKIULLc5XlI7yMg88VlfSfru6Ou8eAdkivbyIRZUNRKPRbhbWCeT0vwfKtoLgHlaTUO773cJ7oBg=
Message-ID: <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
Date: Fri, 27 Apr 2007 22:46:33 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Gregoire Favre" <Gregoire.Favre@gmail.com>
Subject: Re: More than 2Gb problem (dvb related) ?
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <20070427111047.GB10284@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070427111047.GB10284@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

just for the completeness, what does dmesg show up?
You forgot to mention what device you have too...

Markus

On 4/27/07, Gregoire Favre <Gregoire.Favre@gmail.com> wrote:
> Hello,
>
> I have a computer (mother Asus Commando) with 4x1Gb Ram.
>
> If I start without the BIOS remap memory, my BIOS and linux just see 2Gb
> of ram, and DVB apps works just great.
>
> When I enable the remapping of the memory, my BIOS and linux just see
> the whole 4Gb but then, I can tune to any transponder without problem,
> but I am unable to get a TS...
>
> I have tested it with vdr/kaffeine/mplayer.
>
> szap/kaffeine/vdr get the lock just well.
>
> I had already asked about this on just linux-dvb ml, but maybe I am the
> first one to try DVB with a system with more than 2 Gb as I didn't
> receive any further info as someone get it working or not with such
> amount of ram.
>
> Anyone got an idea on what could be done to solve this issue ?
>
> PLEASE CC to me all message in lkml as I am not subscribed to this ml :)
> --
> Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
>                http://picasaweb.google.com/Gregoire.Favre
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
