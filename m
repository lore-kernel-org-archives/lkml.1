Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXDVKMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXDVKMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 06:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXDVKMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 06:12:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:20677 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXDVKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 06:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kvTbqlU1JOE7YIeJOFE2qU/taUOkIHlDvgtPp1ey8+vngtUK/kRo2A2M1agfWnuGqY9SofxEKLGEPB9/qyZsPGGPZRcrls16Fvrw6OEolfA2u3s11mcvGy6xEHUXL9TVyyMEmXfT9+1D0C5Qo4pmlffsEq8aErHk6pWl+8wj/a4=
Message-ID: <653402b90704220312k24ed730ay204ccd076dab8d6c@mail.gmail.com>
Date: Sun, 22 Apr 2007 12:12:11 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "oliver pinter" <oliver.pntr@gmail.com>
Subject: Re: [BUG? -rc7] SMP: Just one CPU activated: P4 3GHz HT
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40704220300n4cfef0f1l652b303f5bab8d1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90704220157h5fe2be3p18c4a341d13ccc87@mail.gmail.com>
	 <6101e8c40704220300n4cfef0f1l652b303f5bab8d1b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, oliver pinter <oliver.pntr@gmail.com> wrote:
> Hello
>
> I have ASUS P4C800, P4 3GHz HT (Nortwood), 512RAM and I have nothing errors
> in my cpu.
>
> in bios have you HT option enabled
>

Sure, and the hardware is fine as other kernels and other systems (as
WinXP) work fine.

> or im =<2.6.21-rc7 functioniert?
>

?

The only big difference I see is that you did not set CONFIG_PREEMPT.
However, that should not matter. Any other general options are almost
the same.

(please CC linux-kernel)

thanks,

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
