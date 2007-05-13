Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbXEMO3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbXEMO3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 10:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbXEMO31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 10:29:27 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:35220 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658AbXEMO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 10:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADzAhnsE89g62/mEEaLvR5eJI/PZRfy/nTZIJdnbu76JF9DeFaWIoDTaY2KdbjB9ncINiYFLKWRzlDqf0ZZlJTwglfN/s25Mlf5mEXS1RNusGENAxK3n0eXR8ESRRMlthwRtqbuVM+WlYuxtmo3c+aePnP9PRTjvH0IL6hdoeiI=
Message-ID: <6bffcb0e0705130729n2c47f0f4h6791ac4b74b9bb62@mail.gmail.com>
Date: Sun, 13 May 2007 16:29:25 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Vladimir Pouzanov" <farcaller@gmail.com>
Subject: Re: ACPI Power Down is broken in 2.6.21.1
Cc: "Len Brown" <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070508T175303-27@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20070508T175303-27@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

[adding Len and ACPI gurus to CC]

On 08/05/07, Vladimir Pouzanov <farcaller@gmail.com> wrote:
> Hi all,
>
> I have got a problem with Asus F3T notebook and 2.6.21.1 kernel. When I
> perform powerdown (with user-space app or alt+sysrq+o) I get "Power Down."
> message, but the notebook doesn't turn off. Everything is ok on 2.6.20.
>
> There seem to be no changes in acpi/sleep/poweroff.c so I don't know where
> should I start looking for a bug.
>
> F3T is based on Thrion64 X2 CPU (I'm running it in x86 mode with SMP and
> PREEMPT).
>
> Sincerely,
> Vladimir "Farcaller" Pouzanov
> http://hackndev.com
>

I added this bug to the list of known regressions.
(http://kernelnewbies.org/known_regressions)

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
