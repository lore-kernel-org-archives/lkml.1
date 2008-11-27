Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYK0MZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYK0MZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYK0MZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:25:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:2892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0MZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:25:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xQcjLIGXGs8/GUern60wmJtzgNlUV4aNOCMFQRjHEi83oNmobwnn6HhBz5hr71ITCX
         Ujc8Dtc0tOfJv3x8osNMbtJJJ9HnW0aC4N8y66nndxlG7LgyRS45QG7mo9kJ3KKOdJfp
         +eJQtaEKqqzjaO+SFIKUwYvcnGBBor7TS+TsM=
Message-ID: <aa79d98a0811270425o7735c950t99326512684b98e3@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:25:07 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 5/5] x86: entry_64.S - trivial: space, comments fixup
Cc: "Alexander van Heukelum" <heukelum@fastmail.fm>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081127120230.GB4259@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
	 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
	 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
	 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
	 <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
	 <fbfac26820d86fa887adfbfa8ac80b369de00075.1227725632.git.gorcunov@gmail.com>
	 <1227782341.31610.1287042073@webmail.messagingengine.com>
	 <20081127120230.GB4259@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 3:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
>
>> On Wed, 26 Nov 2008 22:17:04 +0300, gorcunov@gmail.com said:
>> > From: Cyrill Gorcunov <gorcunov@gmail.com>
>> >
>> > Impact: cleanup
>> >
>> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>>
>> Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
>
> Cyrill, could you please rework the still relevant bits against latest
> tip/master? Alexander's wider patch got in the way.
>
> Thanks,
>
>        Ingo
>

yep, no problem (wait 'till evening please)
