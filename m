Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZCFJtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZCFJtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZCFJtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:49:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:35489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZCFJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RZThOOMaI4i6DxlCXNsQubWK1bNA/SfTHjjRlK90++3dKKK9pigN82SpGgVRxUZei7
         I6wzbBOpQjeA2xR1BSo2A5dMdEy2t7yJ73Z1yEJmfsCGSxpeV2sOE8ff5atqBiYpU7FN
         T2KSpErvQhPOCQ7ghIaV5rjmHLr9X/Jkn5fu4=
Message-ID: <49B0F1D0.9070707@gmail.com>
Date: Fri, 06 Mar 2009 10:50:08 +0100
From: Karl Beldan <karl.beldan@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: broonie@opensource.wolfsonmicro.com, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix bug - kernel
 will crash when record and play in bf527-ezkit
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-3-git-send-email-cooloney@kernel.org>
In-Reply-To: <1236326010-683-3-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> set constraint only if the value is not 0, change the configuring way for sport
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  sound/soc/codecs/ssm2602.c |   29 ++++++++++++++---------------
>  1 files changed, 14 insertions(+), 15 deletions(-)
>
What tree is this against ?

-- 
Karl Beldan
