Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXEAQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXEAQii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXEAQii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:38:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:54912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXEAQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ghwt+Mcai3JCKRO3xXscHLlY3kasv6FDcxv7T0MqTil6oXAwROwQLYocXYXw3WeyeyVGqeXFbZ4LCRqWHIhc8v2Ew/wcBg7szRURY9QSXYz72bKcCKl55x52fL0Bpzje4iklez4Ux8A9w0inNAsP5Kl5wUvf8aUs6Gy2miWRtEw=
Message-ID: <46376D14.9060803@gmail.com>
Date: Tue, 01 May 2007 20:38:44 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: ian <spyro@f2s.com>
CC: Paul Sokolovsky <pmiscml@gmail.com>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
References: <1354376306.20070501080806@gmail.com>	 <46374645.2030900@gmail.com> <1178034935.15769.3.camel@wirenth>
In-Reply-To: <1178034935.15769.3.camel@wirenth>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ian wrote:
> On Tue, 2007-05-01 at 17:53 +0400, Dmitry Krivoschekov wrote:
>> Hi Paul,
>
>> I think your referring to the term "SoC (system-on-chip)" is confusing
>> (at least for me). You rather consider companion chips than SoCs.
>
> A 'System' does not imply a CPU. A 'Computer System' would but the word
> system itself doesnt even imply electronic.
>
>
A "system" means something complete. Yes I agree it doesn't imply a CPU,
but acronym SoC traditionally imply something different than you propose.
Adding another meaning for SoC will confuse people because they will have
to distinguish if it is a processor or just a slave IC.


Thanks,
Dmitry


Thanks,
Dmitry
