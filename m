Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYIQFzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYIQFzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 01:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYIQFzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 01:55:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYIQFzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 01:55:33 -0400
Message-ID: <48D09BC2.1040704@manoweb.com>
Date: Tue, 16 Sep 2008 22:55:14 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Ben Nizette <bn@niasdigital.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver for tightly coupled memory
References: <48CEC71F.3000006@manoweb.com> <20080916093513.GF1916@fluff.org.uk> <48CFEF3F.5040901@manoweb.com> <1221604022.3598.4.camel@moss.renham> <48D03811.9070805@manoweb.com> <24229.1221619342@turing-police.cc.vt.edu>            <48D0954D.4070302@manoweb.com> <32819.1221629978@turing-police.cc.vt.edu>
In-Reply-To: <32819.1221629978@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/BGM91PW1FgxTLdKsIqp6kUWEYs59/YfbWuuz
 QG+gKjFcKxQtO0/YYh998ff5YARfffpeLDXjdLjW5kTH0WBS7U
 otFA5zipZx9OI81yDo2fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> Would it be more of a performance win to use the 8-32K to store speed-critical
> code rather than a FIFO?  Just another idea for what to use it for, but that
> would likely require a different API...

Well... I have to check but I think the cache memory is anyway faster
than this, and this memory is not cacheable. But, you definitely have a
point. I'll check with some hardware guy tomorrow morning.

bye!
as

