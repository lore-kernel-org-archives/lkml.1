Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbZACDbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbZACDbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZACDbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:31:35 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:39859 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZACDbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=T1Y6nb4TqHUlPwTldMNs7bD1D1lmr172odX2QZHX8ly/Brd/jeiCBWXGc8KWe3orMu
         MjqOKR0C6V7uiB1B3YMKeqF0gZEBxCJWl1o8NYRwr90NQ83BNz5pLwBO0bEhFRct+1k2
         VAVw9mpQ52F6yb85Ww/cdC3jnHEHrRHsnjZqE=
Message-ID: <495EDC10.20605@gmail.com>
Date: Fri, 02 Jan 2009 19:31:28 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ath9k microwave anomaly
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com>
In-Reply-To: <20090103032134.GA20209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Jan 02, 2009 at 06:47:32PM -0800, Justin P. Mattock wrote:
>  > Now I'm not trying to be funny,
>  > but I think I figured a problem
>  > with running ath9k, and having the internet
>  > timeout.(for me at least);
>  > When streaming T.V.(cspan2), and
>  > streaming music(somafm), at the same time,
>  > then using the microwave, I'll experience a blackout
>  > of internet(T.V. stops, then music stops streaming);
>
> not specific to ath9k.
>
> http://blogs.zdnet.com/Ou/?p=578 has some pretty graphics
> to show just how much noise a microwave puts into the part
> of the spectrum wifi uses.
>
> 	Dave
>
>   
Damn that's allot,
no wonder I was having these timeouts.
i.g. system streams fine for 10 hours.
then the next day a timeout after 2 hours due
to microwave use.
Thanks for pointing that blog out.
that opened my eyes up to how powerful
a microwave is. makes me wonder if that
grade in the window actually does what is supposed to.
(block gamma rays or whatever the dangerous wave is);

regards;

Justin P. Mattock

