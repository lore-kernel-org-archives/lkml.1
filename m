Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZFAFHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZFAFHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZFAFHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:07:31 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:41231 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZFAFHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=blz6W/y7KaN9Ctc6IZTQhawIkqtKo/y/C6lknbRw3RDnPdBwtxv1Y9IAfHo75IPMln
         MLInToTtU0GVoxtjr3BRHlvZRkc0l5dGFm2e1ATnXHliLVW0DbUw1mU8tale4J75ibKl
         evKLPRQMy0GLbjahpcvlQ3C22wheir1kXIYpc=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel]  [PATCH] Support NVIDIA 8 channel HDMI audio
Date: Mon, 1 Jun 2009 07:07:30 +0200
User-Agent: KMail/1.9.9
Cc: "Wei Ni" <wni@nvidia.com>, "Takashi Iwai" <tiwai@suse.de>,
       Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Hofman <pavel.hofman@insite.cz>, akpm <akpm@linux-foundation.org>
References: <15F501D1A78BD343BE8F4D8DB854566B058A63E9@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B058A63E9@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906010707.30788.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 of June 2009 04:51:16 Wei Ni wrote:
> Hi, Takashi
> I'm a Nvidia engineer, we wish to support 8 channel HDMI audio for
> MCP78/7A.
>
> I attached the patch file, it based on the latest sound git tree,
> please check it.
>

Hi,
can you please run scripts/checkpatch.pl on the patches you submit? I'd help a 
lot, thanks.

btw. here's the output (shortened):

total: 47 errors, 15 warnings, 349 lines checked

0001-Support-NVIDIA-8-channel-HDMI-audio.patch has style problems, please 
review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

>  <<0001-Support-NVIDIA-8-channel-HDMI-audio.patch>>
>
> Thanks
> Wei.
>
> ---------------------------------------------------------------------------
>-------- This email message is for the sole use of the intended recipient(s)
> and may contain confidential information.  Any unauthorized review, use,
> disclosure or distribution is prohibited.  If you are not the intended
> recipient, please contact the sender by reply email and destroy all copies
> of the original message.
> ---------------------------------------------------------------------------
>--------


