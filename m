Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbZACEoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbZACEoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZACEoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:44:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:12597 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZACEoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mnVabIJJczsxBG6uZK1qyJMjG+jNDuTnWh9FHo1y1DIp42Lft3+LetmDeBBEBKYNmD
         LTOeFg8Jhr6NzEodxwDTIgWYsXM5B1BafA1a+liYaM8sitOqTJO8RV8ftIA71k7xqtWh
         4uncgY4RpdLXDXBsUm51wAPfA2IjkMD4dSMtU=
Message-ID: <d204e3110901022044l2cf57f54yd52a2d331d69deef@mail.gmail.com>
Date: Sat, 3 Jan 2009 12:44:03 +0800
From: "Baodong Chen" <chenbdchenbd@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Subject: [PATCH] Documentation/x86/boot.txt:payload length was changed to payload_length
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090102092659.GC1975@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com>
	 <20090102092659.GC1975@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 5:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Baodong Chen <chenbdchenbd@gmail.com> wrote:
>
>>  Documentation/x86/boot.txt:payload length was changed to payload_length
>>
>> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
>>
>> ---
>>  Documentation/x86/boot.txt |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> looks good but the patch was whitespace damaged (all tabs were spaces and
> there were linewraps as well), please check
> Documentation/email-clients.txt and resend the patch. Thanks,
>
>        Ingo
>

I referred to Documentation/email-clients.txt:Gmail and resent the patch. I am a
newbie,if i made any mistake,please do me a favor and help me.Thanks!
