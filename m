Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbXLUPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbXLUPT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXLUPTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:19:19 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:54231 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXLUPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:19:19 -0500
Message-ID: <476BD94F.6060002@s5r6.in-berlin.de>
Date: Fri, 21 Dec 2007 16:18:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, joe@perches.com,
       davem@davemloft.net, apw@shadowen.org, lizf@cn.fujitsu.com,
       akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 21 2007 17:56, Herbert Xu wrote:
>>As to what is a complete sentence, that is debatable.  However,
>>typically it would include a subject and a predicate.  By this
>>rule the following line is not a complete sentence:
>>
>>	[XFS] Initialise current offset in xfs_file_readdir correctly
>>
>>The reason is that it lacks a subject.
> 
> "current offset" is your subject.

It's an object, not the subject.

The quoted changelog heading is a complete sentence nevertheless, as it
is an imperative sentence.  Its subject is implied.

It could end in a period or in an exclamation mark.  But as it's
actually a heading, it doesn't have to and probably shouldn't.
-- 
Stefan Richter
-=====-=-=== ==-- =-=-=
http://arcgraph.de/sr/
