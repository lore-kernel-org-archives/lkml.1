Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZAXW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZAXW4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 17:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZAXW4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 17:56:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60201 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZAXW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 17:56:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <497B9C80.1010108@s5r6.in-berlin.de>
Date: Sat, 24 Jan 2009 23:56:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Peter Hallberg <hallberg68@hotmail.com>
CC: arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: EXTRA_VERSION in #if LINUX_VERSION_CODE >= KERNEL_VERSION(x,x,x)
References: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl> <20090124080100.0843df1a@infradead.org> <BLU122-W460604D42E2337F7CA32D4DACC0@phx.gbl> <497B9C13.4020802@s5r6.in-berlin.de>
In-Reply-To: <497B9C13.4020802@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Peter Hallberg wrote:
>> Since I maintain an separate filesystem module
...
> #define AOP_FLAG_NOFS			0x0004
> to <linux/fs.h>.  You could check for it with #ifdef.

(Don't understand this as general encouragement to maintain stuff
outside the mainline...)
-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/
