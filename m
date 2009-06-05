Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZFEFzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZFEFzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZFEFzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:55:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49390 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZFEFzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:55:06 -0400
Message-ID: <4A28B324.2090806@nokia.com>
Date: Fri, 05 Jun 2009 08:54:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>
Subject: Re: linux-next: ubi tree build failure
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>	<4A265DF6.3070602@nokia.com> <20090605105842.de948d0b.sfr@canb.auug.org.au>
In-Reply-To: <20090605105842.de948d0b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Jun 2009 05:54:49.0804 (UTC) FILETIME=[2364C8C0:01C9E5A2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Always directly include the header files for APIs you use ...

Yes, right, those were forgotten.

> I see that this particular problem is now fixed, thanks.

Good, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
