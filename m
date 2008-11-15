Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYKOPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYKOPBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKOPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:01:34 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:62030 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYKOPBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:01:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kCPXz+dfdQaOiOrZD63iFAcTRJ5DID5TFuG2vsnF2BhEzKogHgvkjYxKwn6xPuDV1z
         KgFhAuxoVUznxUaV6wtieOb2arTe4MSCu3+bKpu3jstnW47y2CxOsxqWqw4lSFubzYVG
         UGiEOUBRccPsu3ohmcddPEJXhlv1LUY4wfvmc=
Message-ID: <9b06e8d20811150701q6e38148k18df241343262713@mail.gmail.com>
Date: Sat, 15 Nov 2008 16:01:32 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: Linux 2.6.27.6
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <877i75p4ra.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081113185350.GA3765@kroah.com>
	 <9b06e8d20811150238ye81f6dck7e81e275ba11da9d@mail.gmail.com>
	 <877i75p4ra.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/15 Elias Oltmanns <eo@nebensachen.de>:
> "Loïc Grenié" <loic.grenie@gmail.com> wrote:
>>     No big deal, but commit 093327cb references
>>   X86_CHECK_BIOS_CORRUPTION that is not available anywhere.
>
> You are talking about commit 71556e92, I suppose. Since the change log
> entry has been written for the original commit 5649b7c3 in Linus' tree,
> it refers to a feature that is available there
> (X86_CHECK_BIOS_CORRUPTION) but has only been merged into mainline after
> the release of 2.6.27.

    No, I really mean 093327cb because it modifies arch/x86/Kconfig and in the
  help for X86_RESERVE_LOW_64K it references
  X86_CHECK_BIOS_CORRUPTION that, as you say, exists only in 2.6.28-rc?

         Loïc
