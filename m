Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXGPHvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXGPHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXGPHvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:51:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56102 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXGPHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:51:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469B2372.2040004@s5r6.in-berlin.de>
Date: Mon, 16 Jul 2007 09:51:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: jimmy bahuleyan <knight.camelot@gmail.com>
CC: TripleX Chung <triplex@zh-kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Ask for help, about the trivial patches.
References: <4697C980.1040902@zh-kernel.org> <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com> <469A4B9B.4040008@zh-kernel.org> <469A6B1A.2040908@gmail.com>
In-Reply-To: <469A6B1A.2040908@gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jimmy bahuleyan wrote:
> TripleX Chung wrote:
>> But I still have problems.
>> Trivial means "of little worth or importance". But some of the examples
>> in the rules are important, like "runtime fixes". Spell fixes must be
>> unimportant, but most of the runtime fixes like memory leaks or NULL
>> pointers must be important. I was still a little confused with them.
>>
> 
> Literally, yes. But look at it from a s/w engineering point of view.
> 
> A NULL pointer deref is important, but it is also a *very local* and
> very obvious fix (one that doesn't need extensive testing, one that
> doesn't have effects spread out over many modules that requires great
> amount of thought).
> 
> So such things are trivial bug-fixes.

Yes; it's more the /handling/ of the patch that is "trivial" in a strict
sense.  Bug fixes should usually go through maintainers.  But for fixes
which are obvious == easy to verify, trivial@kernel.org makes sense as a
central point for submitters to turn to, to lower the barrier for
submission.
-- 
Stefan Richter
-=====-=-=== -=== =----
http://arcgraph.de/sr/
