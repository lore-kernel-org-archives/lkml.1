Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZALKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZALKnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZALKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:43:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:58467 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZALKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BzZqpgFxbz5Fl58i6tt/yNEG8NcxfTAfnSixxVce9nrlXExFa943W0NEtJsz8SdfJq
         j2qXVC90A+3ULIJTd7ud/kmZ8gDRjkgsXP9KrafiRXp2k/QSQT0zWw/XyhSbZZdyzWMq
         hJQeGpvLZfR+TJ48Oj/sCSsTRqcy/sTERwvFA=
Message-ID: <3f9a31f40901120243u5ca60bc6n31dee913a02a081a@mail.gmail.com>
Date: Mon, 12 Jan 2009 16:13:22 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PULL -tip] x86: fix style problems in microcode_intel.c, msr.c and module_XX.c
Cc: "Jaswinder Singh Rajput" <jaswinder@infradead.org>,
       "H. Peter Anvin" <hpa@kernel.org>, tigran@aivazian.fsnet.co.uk,
       shaohua.li@intel.com, rusty@rustcorp.com.au,
       "Andi Kleen" <andi@firstfloor.org>, "x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090112102011.GB10405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231753169.7087.5.camel@jaswinder.satnam>
	 <20090112102011.GB10405@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> hm, are the mpparse.c structural cleanups that i suggested some time ago
> still on your list? I think the functions replace_intsrc_all(),
> smp_scan_config() and smp_read_mpc() need those cleanups.
>

Yes, it is still in my TODO list. But before that I need to submit
patches to get some extra space:
0001-x86-replacing-mp_config_ioapic-with-mpc_ioapic.patch
0002-x86-replacing-mp_config_intsrc-with-mpc_intsrc.patch

And then I will make final changes in mpparse.c

Thanks,

--
JSR
