Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXLQNOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXLQNOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXLQNO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:14:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38666 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXLQNO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:14:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4766760A.50902@s5r6.in-berlin.de>
Date: Mon, 17 Dec 2007 14:13:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
CC: Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com>	 <4763F771.10105@s5r6.in-berlin.de>  <20071217025129.GA12815@redhat.com> <1197894814.18713.36.camel@perihelion>
In-Reply-To: <1197894814.18713.36.camel@perihelion>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Sun, 2007-12-16 at 21:51 -0500, Dave Jones wrote:
>> On Sat, Dec 15, 2007 at 04:49:05PM +0100, Stefan Richter wrote:
>>  
>>  > Reports about tainted kernels have arguably less value.  It would be
>>  > good to hide such reports until a report of the same oops in an
>>  > untainted kernel was found.
>>  
>> I disagree with this.  It's useful to have a "we've seen this before,
>> and every time, it was tainted with xyz module" datapoint, especially
>> if no untainted copies of that oops turn up.
> 
> +1
> 
> In fact, that's even more useful in many cases, if it helps demonstrate
> that the oops is associated with a particular buggy binary driver. I can
> see a lot of potentially interesting statistics coming from that too.

-1  :-)

I don't care at all what this xyz module does or does not do by and in
itself.

(Of course since at least two people care and since this makes life
easier for Arjan, just keep listing reports about tainted kernels like
you do now.  It just so happens that different people are interested in
different things.)
-- 
Stefan Richter
-=====-=-=== ==-- =---=
http://arcgraph.de/sr/
