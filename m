Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZIILOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZIILOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZIILOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:14:31 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:60069 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZIILOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:14:30 -0400
Message-ID: <4AA78E15.9090206@davidnewall.com>
Date: Wed, 09 Sep 2009 20:44:29 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Frans Pop <elendil@planet.nl>, Arjan van de Ven <arjan@infradead.org>,
       realnc@arcor.de, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org>	 <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de>	 <4AA6056A.4020106@arcor.de> <20090908013133.59203403@infradead.org>	 <200909082222.44828.elendil@planet.nl> <1252489988.26522.46.camel@pasglop>
In-Reply-To: <1252489988.26522.46.camel@pasglop>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2009-09-08 at 22:22 +0200, Frans Pop wrote:
>   
>> Arjan van de Ven wrote:
>>     
>>> the latest version of latencytop also has a GUI (thanks to Ben)
>>>       
>> That looks nice, but...
>>
>> I kind of miss the split screen feature where latencytop would show both 
>> the overall figures + the ones for the currently most affected task. 
>> Downside of that last was that I never managed to keep the display on a 
>> specific task.
>>     
>
> Any idea of how to present it ? I'm happy to spend 5mn improving the
> GUI :-) 

Use a second window.
