Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZGAU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZGAU1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZGAU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:27:33 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64752 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZGAU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NObKlnE+b+T1wW6F3iP8hBHcny0qtLIVLeDiYgMd6SwC572O2EY38AWl9WVgRg0kAj
         iC+bbiUH35j0raqMyMelMB54AvnUN5yTSznNolrfFSE1upw/nh6i9NgsASMTbYTU+VBE
         qvkDRetKhjSE/IWzwDaZ4fY//G8DtYTB542og=
MIME-Version: 1.0
In-Reply-To: <4A474EFF.5030607@cs.helsinki.fi>
References: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
	 <4A474EFF.5030607@cs.helsinki.fi>
Date: Wed, 1 Jul 2009 22:27:32 +0200
Message-ID: <19f34abd0907011327h7e90ec68r7ad0ed8666abafac@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: depend on HAVE_ARCH_KMEMCHECK
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/28 Pekka Enberg <penberg@cs.helsinki.fi>:
> Sebastian Andrzej Siewior wrote:
>>
>> to make it selectable if it is available
>>
>> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>
> Looks good to me! Thanks.
>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Applied, thanks.


Vegard
