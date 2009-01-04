Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZADNtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZADNtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbZADNt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:49:27 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:53834 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZADNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tX/lox+ePpkmenvFZhgquCQXBh5MrvfCiRcmyeiS0auwUx2aha8wN0CkSyPtHsqrfy
         ZcZulDMnKTSXHQQj7dIus0ey0baCs2X5HaCrWCavDNOPoEFigpj17f8WEZa4XHggyE8B
         N0TzTtMOFYyGBaE5eaoqVmA7bx4+/TR72UI08=
Message-ID: <d204e3110901040549g20273205s1696ae791b04f1ac@mail.gmail.com>
Date: Sun, 4 Jan 2009 21:49:24 +0800
From: "Baodong Chen" <chenbdchenbd@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Subject: [PATCH] Documentation/x86/boot.txt:payload length was changed to payload_length
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090104125713.GD15472@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com>
	 <20090102092659.GC1975@elte.hu>
	 <d204e3110901022044l2cf57f54yd52a2d331d69deef@mail.gmail.com>
	 <20090104125713.GD15472@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 8:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Baodong Chen <chenbdchenbd@gmail.com> wrote:
>
>> On Fri, Jan 2, 2009 at 5:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Baodong Chen <chenbdchenbd@gmail.com> wrote:
>> >
>> >>  Documentation/x86/boot.txt:payload length was changed to payload_length
>> >>
>> >> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
>> >>
>> >> ---
>> >>  Documentation/x86/boot.txt |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > looks good but the patch was whitespace damaged (all tabs were spaces and
>> > there were linewraps as well), please check
>> > Documentation/email-clients.txt and resend the patch. Thanks,
>> >
>> >        Ingo
>>
>> I referred to Documentation/email-clients.txt:Gmail and resent the
>> patch. I am a newbie,if i made any mistake,please do me a favor and help
>> me.Thanks!
>
> it's OK, and your resubmission was better - but it still had a linewrap
> problem (i was able to fix that up manually).
>
> this bit:
>
> @@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised
> boot protocol.
>                and KEEP_SEGMENTS flag in load_flags.
>
> [3 lines]
>
> should have been:
>
> @@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised boot protocol.
>                and KEEP_SEGMENTS flag in load_flags.
>
> [2 lines]
>
> If you post from gmail it might make sense to send patches as MIME
> attachments, we can process them just fine. (as long as you send patches
> that go via -tip - other maintainers have different policies regarding
> MIME attachments)
>
>        Ingo
>
I am sorry for my linewrap problem.i used Gmail GUI with gedit to write
the mailbody.you meat that if i send path via -tip, i can send my patch
content as attachment file?got it...
