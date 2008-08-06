Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYHFP5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYHFP5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764175AbYHFP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:57:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:45813 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764142AbYHFP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tWG0SwJ0pmhdkGcCzm/MiSCOX1YT/+0GlbERl76S0YH1RLMt3ud0WhYWKJyBSM04TT
         c0DzZIlmt5Hu5QyjvaGAKx7Fj6XfZcFuoGbfRmPb84Ph1ynshqYeQdftRO1fFFO44hOv
         D4ZoMKGgUDObBKM4DrwdPP4L8gtY6+vAV0pJs=
Message-ID: <b647ffbd0808060857y498a78b7tfa8141b40ada43a4@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:57:24 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via workqueue.
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0808060856j33bb8ffey1cc32665bd88c071@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806152117.198754464@amd.com>
	 <20080806152319.773811325@amd.com>
	 <20080806084446.68683aaf@infradead.org>
	 <b647ffbd0808060856j33bb8ffey1cc32665bd88c071@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/6 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2008/8/6 Arjan van de Ven <arjan@infradead.org>:
>> On Wed, 6 Aug 2008 17:21:20 +0200
>> Peter Oruba <peter.oruba@amd.com> wrote:
>>
>> [ no description or reason ]
>>
>> Why is this?
>
> More details are available here.

forgot a link:

http://lkml.org/lkml/2008/8/3/114


-- 
Best regards,
Dmitry Adamushko
