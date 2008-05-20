Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbYETMe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbYETMe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYETMet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:34:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYETMes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:34:48 -0400
Message-ID: <36b30e3d53d743626dc8cbc080f928c1.squirrel@housecafe.dyndns.org>
In-Reply-To: <1211211433.6283.14.camel@norville.austin.ibm.com>
References: <482C9090.5040901@mrxfx.com>
    <1211211433.6283.14.camel@norville.austin.ibm.com>
Date: Tue, 20 May 2008 14:19:17 +0200 (CEST)
Subject: Re: [Jfs-discussion] Hello and a question about high cpu usage on 
     jfsCommit (kernel	2.6.25.1)
From: "Christian Kujau" <lists@nerdbynature.de>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Cc: "David Fix" <davidf@mrxfx.com>,
       "JFS Discussion" <jfs-discussion@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX1+s+VCcNFjinyCIbMnYVE3C62AZtc/bAZMZmPF
 lOZYF6auiA0prG/LNg0m+wK2D/1FoWxNDz2A/lz6+jV3Rwvret
 0FX2dVZKWShp+W/ZOULgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 17:37, Dave Kleikamp wrote:
>> PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>> 2669 root      15  -5     0    0    0 R   99  0.0  19:45.71 jfsCommit
>>
> This is highly unusual.  Is this thread continually eating cpu at this
> rate, or does it happen in spurts?

Would oprofile[0] help to see what jfsCommit is doing here?

C.

[0] http://oprofile.sf.net
-- 
make bzImage, not war

