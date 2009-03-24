Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZCXXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZCXXjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZCXXjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:39:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:34847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbZCXXjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uol/78w/hh7EspEfu4ohPvBU//IaTK3gxPubUT3FcadOjloeYUMYZpRuP2g9xtu/IV
         pKkLc8rXWcnXdPSgmqg55iC7Obz1FAP2TN3K4Wd49EpxbRAnlQOPVLO/2YxegHU/mQFw
         Y1Fbvx7Ag+Hp0KYnyTptTuDqJ3Ys76TMaP+8Y=
MIME-Version: 1.0
In-Reply-To: <49C96978.6050904@zytor.com>
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com>
	 <20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com>
	 <ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com>
	 <20090322233502.GC1114@deepthought>
	 <ff479ab60903232343k2448a11dtebe21df6acb24a5f@mail.gmail.com>
	 <49C96978.6050904@zytor.com>
Date: Wed, 25 Mar 2009 01:39:05 +0200
Message-ID: <94a0d4530903241639g71c1d519jf01740e10c9342d0@mail.gmail.com>
Subject: Re: My new fancy font for framebuffer
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Baybal Ni <nikulinpi@gmail.com>, Ken Moffat <zarniwhoop@ntlworld.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 1:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Baybal Ni wrote:
>>
>> So, why not just to squeeze the whole kbd into the kernel? =D, or you
>> want the way how to inject bdf blob compiletime? These way it would
>> violate the GPL almost the same way as you have already said.
>>
>
> No, it wouldn't.  The fundamental requirement of the GPL is distribution of
> the preferred editable format, which in this case is the BDF (and the
> unicode files.)
>
>> Why you are so unhappy about GPL in GPL? I Think that it is perfectly
>> ok as long as it goes along with 4 basics of GPL. And it does along
>> with it.
>
> It has nothing to do with "4 basics", it has to do with the literal
> specification in the license. ssencessence There is nothing wrong with
> incorporating code from another GPL'd project (quite on the contrary, it's
> encouraged), but it has to be in source code form -- a C file which contains
> a processed binary is not source.
>
> Of course, you could contact the author and get a special exception, too (in
> which case this should be declared in the file.)

I thought you had to distribute the source code only if you made
modifications. What's the point of distributing it _again_?

-- 
Felipe Contreras
