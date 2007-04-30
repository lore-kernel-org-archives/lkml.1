Return-Path: <linux-kernel-owner+w=401wt.eu-S1423211AbXD3MqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423211AbXD3MqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXD3MqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:46:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:62627 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423211AbXD3MqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ITzV9l/SN9Mr+3ggULtvNdCAbiidiRc2ykc1XS4N3vCIQ5rmXfMfH0sXR8fPakXl+f/zHkLE3pveMBt+gzSxDir3LVHLNdBMFGmo01ZuAab/y90YkdWqjd3kbUsx8PK4aXbJv0aDBWoytrFxv1dO+8yfUF5JKFPALSmojo24cXQ=
Message-ID: <6bffcb0e0704300546w1eff1a92gff047117e9e756e@mail.gmail.com>
Date: Mon, 30 Apr 2007 14:46:00 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Sebastian Kemper" <sebastian_ml@gmx.net>
Subject: Re: 2.6.21: ACPI related kernel panic
Cc: "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070430122940.GA25848@anna.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430122940.GA25848@anna.darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30/04/07, Sebastian Kemper <sebastian_ml@gmx.net> wrote:
> Hello all,
>
> I have updated some different boxes to 2.6.21 with success. One laptop,
> though, has some issue with it.
>
> It's an Acer TravelMate 4002WLMi. Sometimes it boots fine and sometimes
> not. Thanks to netconsole you can see what happens when it boots fine in
> the attached bootsie.out.good. bootsie.out shows what happens on the
> screen when things get out of hand (kernel panic).
>
> Also attached you'll find the output of lspci, lsusb, ver_linux and the
> kernel configuration.
>
> If there's more you need (git bisection or more info in general,
> testing ...) just say so.
>
> Thanks in advance!
>
> Regards
> Sebastian
>
> P.S.: Please CC.
>
>

I added this to the list of known regressions.

Len and ACPI folks CC'ed.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
