Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXCJW1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXCJW1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbXCJW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:27:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:4672 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbXCJW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=beW73Y4zHBzr/Gw/j4+3+7ESYbuIv5TYm6wivP5SlYQmNeN3KQHZ6PIed+ron7XF2/afmpF8Yh27TXv3oQo/3QVt9phFv3J6UPLLbE8IicA+DB+q/vXGFho7Q+Ra1uBw2kVvF6KquPodLlZX5tbepXzDoD8TpAWL9vTl16KNDqc=
Message-ID: <b14e81f00703101426k1cc9d4ar465107fcb2a9bc8@mail.gmail.com>
Date: Sat, 10 Mar 2007 17:26:58 -0500
From: "michael chang" <thenewme91@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [ck] Re: RSDL v0.28 for 2.6.20
Cc: "Stephen Clark" <Stephen.Clark@seclark.us>, "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070310221150.GA6274@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703101845.59497.kernel@kolivas.org>
	 <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu>
	 <b14e81f00703101356s248bd914m91c26e2d22e507d4@mail.gmail.com>
	 <20070310221150.GA6274@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/07, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Mar 10, 2007 at 04:56:57PM -0500, michael chang wrote:
> > On 3/10/07, Willy Tarreau <w@1wt.eu> wrote:
> > >BTW, Con, I think that you should base your work on 2.6.20.[23] and not
> > >2.6.20 next time, due to this conflict. It will get wider adoption.
>           ^^^^^^^^^^
>
> > Maybe I'm naive, but I find this hard to understand -- 2.6.20.2 didn't
> > exist when Con published his patch. (Con published it ~12 hours before
> > the release of 2.6.20.2, from what I can tell.) How can he base his
> > work on something that didn't yet exist? (And it applied cleanly to
> > 2.6.20.1, the latest when he published it.)
>
> You see the words I have underlined ? "next time". I know for sure he
> published it before 2.6.20.2, but now that it is out, I suggested that
> Con rebases his work on this version for new releases.
>

Oh. That's my mistake, then. That makes sense. To me, it sounded like
you were implying he was supposed to base it on 2.6.20.2 in advance,
for some reason. *sigh*

-- 
~Mike
 - Just the crazy copy cat.
