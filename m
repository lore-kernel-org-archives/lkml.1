Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbXH0Apd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbXH0Apd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 20:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXH0ApZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 20:45:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:53925 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXH0ApY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 20:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=uFMuFM6fEy/1hb1oHTTX6nR0+ShjQX6u7nP4F4dWOsFnIgPFe5MGFyaD1i2aUEffj2WqBe48QheJj7wVLuPG87WziMVgEE/E5kd/oIqygunWTz2K/c5VTTr2C7bWMp58ipPLp99Nk+fdqa6t5gue/VLushy/QcgdjjJOUiXL04g=
Message-ID: <46D21E8E.4000003@googlemail.com>
Date: Mon, 27 Aug 2007 02:45:02 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       =?UTF-8?B?QmrDtnI=?= =?UTF-8?B?biBTdGVpbmJyaW5r?= 
	<B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2
 regression in 2.6.21)
References: <1186531609.22044.50.camel@imap.mvista.com>	 <20070808142059.GF30805@atjola.homenet>	 <1187628296.7732.14.camel@imap.mvista.com>	 <46CDE94A.7000600@googlemail.com> <1187904169.2435.83.camel@dhcp193.mvista.com>
In-Reply-To: <1187904169.2435.83.camel@dhcp193.mvista.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker pisze:
[snip]
> Have you considered maintaining all the lists in Bugzilla?

Yes, I have considered it.

Bugzilla sucks when it comes to tracking things. There is
a regression field, but there are no difference between
2.6.22 and 2.6.23 regression.

Most people are reporting bugs through LKML:
- 23 regressions with reference to LKML
- 4 regressions with reference to Bugzilla

> If you had a
> search of open bugs they would just fall of the list as they get
> closed.. 

Unfortunately, the world is not perfect.

Is anyone interested in maintaining KR list for stable releases?

> 
> Daniel
> 
> 

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
