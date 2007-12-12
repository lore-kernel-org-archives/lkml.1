Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbXLLSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbXLLSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXLLSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:52:06 -0500
Received: from smtp25.orange.fr ([193.252.22.22]:10711 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbXLLSwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:52:03 -0500
X-ME-UUID: 20071212185202241.3B03B1C000EE@mwinf2516.orange.fr
Message-ID: <47602DD0.8070402@cosmosbay.com>
Date: Wed, 12 Dec 2007 19:52:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <475D7901.1040900@nortel.com> <475D7D70.5030502@nortel.com> <47600A6E.8000202@nortel.com> <47601059.8020203@cosmosbay.com> <4760279E.1080203@nortel.com>
In-Reply-To: <4760279E.1080203@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> Eric Dumazet wrote:
>> Chris Friesen a écrit :
>>> Is this expected behaviour?
>>
>> Probably not... Still a 2.6.14 kernel ?
>
> Yep.  Embedded hardware, so I'm unable to test with a more recent kernel.
>

And what is the version of "ip" command you have on this machine ?

ip -V

You may try other versions of this command

http://devresources.linux-foundation.org/dev/iproute2/download/





