Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYF0QwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYF0QwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYF0Qvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:51:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:29937 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYF0Qvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F2CUP/0bktc0ga3fhopg6OSNaWoqsFkAr/8mZ/aTrYf89V6ILn3D2st+Djd41mNdID
         zdSVKlRpZ9zhFitR9PxkuWIxLpZ5y5zNYBg80CTESN+nTX9WjRZA79rbczX0TkHrr58b
         P/pKaYzQiujVdw81Y0+OE2YH5Kv5Kw1Be5jhs=
Date: Fri, 27 Jun 2008 20:51:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080627165125.GE18957@cvg>
References: <20080627154340.GC18957@cvg> <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl> <20080627165937.2f1fb661@lxorguk.ukuu.org.uk> <4865160C.2040403@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4865160C.2040403@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Chris Friesen - Fri, Jun 27, 2008 at 10:32:12AM -0600]
> Alan Cox wrote:
>> On Fri, 27 Jun 2008 16:54:19 +0100 (BST)
>> "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
>>> On Fri, 27 Jun 2008, Cyrill Gorcunov wrote:
>>>
>>>
>>>> +NOTE: Prior to 2.4.2-ac18 the NMI-oopser is enabled unconditionally
>>>> +on x86 SMP boxes.
>>>
>>> While you are at it: s/is/was/.
>> Erm - why ??
>> It is still true today that kernels < 2.4.2-ac8 have the NMI oopser
>> enabled.
>
> To my ear the phrase as written implies past tense for the author/reader 
> (i.e. "at points in time prior to the release of 2.4.2-ac18"), and thus 
> grates against "is".
>
> The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
> NMI-oopser is enabled..."  In this context the phrase itself is in the 
> present, but we point to past kernels.
>
> Chris
>

And the winner is? I'm not native English speaker so I can't select
a better candidate in {is,was} limited set.

		- Cyrill -
