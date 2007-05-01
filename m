Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbXEAB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbXEAB0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXEAB0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:26:48 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:56892 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbXEAB0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BievTQutdXgJ/wqB88pV+3bELgUBEVnuAgW9ItO+0ilGtbE0pjE2Z3AeuIUOz3EsblxOrzsUPw00Bd/0ApWpu1M7djZ4vK0T7+5e7A1SshlaoHlNfmVal6/rK6aodoNIufuuBBpjny+xu9WhEDLTuYmT/vYaCAo4LvEzOzs12dI=
Message-ID: <8bd0f97a0704301826w2cbd6b33v7361f722c441357d@mail.gmail.com>
Date: Mon, 30 Apr 2007 21:26:46 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/2] wrap access to thread_info
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705010208310.1479@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705010208310.1479@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> This only leaves blackfin in -mm which I'll fix separately

thanks

> (depending on how quickly Andrew is with merging it).

seems to be slated for the 2.6.22 merge window :)
-mike
