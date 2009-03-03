Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZCCBvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZCCBvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZCCBvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:51:44 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:21728 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZCCBvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iH012m+dr3dcKuRETs8AOdAUfyqLLrvlPTdozU65l5ZNVm1Bfq4RRAQvN6ODSJTqbn
         urz434Fz917dfNTGYayz0efh43vMWrRosF1uA7IoT54KEnF+dxyjRG5EiPSXpMYU0aHH
         XZXLGII7aKI1ILBtfSCsIrBYM7fXsPdfipPG8=
MIME-Version: 1.0
In-Reply-To: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>
References: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>
Date: Mon, 2 Mar 2009 17:51:41 -0800
Message-ID: <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>
Subject: Re: hid-dummy.ko Input/output error -- causing huge delays
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 5:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> FATAL: Error inserting hid_dummy
> (/lib/modules/2.6.29-rc6-wl/kernel/drivers/hid/hid-dummy.ko):
> Input/output error
>
> I remember reading a thread where you said this was non-fatal and that
> hid-dummy.ko would go away. On my system, every now in a blue moon the
> above causes a huge delay during the bootup sequence. I'm talking
> about a full 1-2 minute delay. Why is the delay so sporadic?

s/once in a blue moon/often/

as it seems I get this now upon every reboot.

  Luis
