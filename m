Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYHSOLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYHSOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYHSOLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:11:35 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:55499 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYHSOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:11:35 -0400
Message-ID: <48AAD48E.3030409@cetrtapot.si>
Date: Tue, 19 Aug 2008 16:11:26 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: Phil Oester <kernel@linuxace.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iptables-1.4.0 with 2.6.26
References: <48AAAFEB.8020608@cetrtapot.si> <20080819140601.GA5135@linuxace.com>
In-Reply-To: <20080819140601.GA5135@linuxace.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Oester wrote:
> On Tue, Aug 19, 2008 at 01:35:07PM +0200, Hinko Kocevar wrote:
>> Hi,
>>
>> Trying to build iptables-1.4.0 with 2.6.26 kernel on x86 fails with:
> 
> Try 1.4.1.1 instead?
> 

Well, it builds.
But trying to add simple rule fails:

hinkok@alala /tmp/iptables-1.4.1.1 $ sudo ./iptables -A INPUT -p tcp --dport 80 -j DROP
iptables v1.4.1.1: Unknown arg `--dport'
Try `iptables -h' or 'iptables --help' for more information.


Regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

