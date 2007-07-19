Return-Path: <linux-kernel-owner+w=401wt.eu-S935031AbXGSNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031AbXGSNMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXGSNMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:12:09 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:54351 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbXGSNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:12:08 -0400
Message-ID: <469F62D0.4030003@googlemail.com>
Date: Thu, 19 Jul 2007 15:10:40 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: net/ipv4/inetpeer.c stack warnings
References: <469F5941.7090900@googlemail.com> <469F5DBB.3080106@trash.net>
In-Reply-To: <469F5DBB.3080106@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Gabriel C wrote:
>   
>> Hello ,
>>
>> I noticed on current git this warning in net/ipv4/inetpeer.c
>>     
>
> Yeah, I have no idea why the gcc people thought that this was
> something worth warning about. Especially since explicitly
> checking for != NULL silences the warning again.
>
>
>   

Thx , the patch fixes that for me.

Gabriel
