Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXLFWWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXLFWWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXLFWVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:21:51 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36448 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbXLFWVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:21:50 -0500
Message-ID: <475875F9.3090503@davidnewall.com>
Date: Fri, 07 Dec 2007 08:51:45 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Renzo Davoli <renzo@cs.unibo.it>,
       linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <2BD0AF2A-959D-4744-9D2A-3AE84CF96CBB@mac.com> <47579DEB.9020102@davidnewall.com> <20071206163451.GB20595@one.firstfloor.org>
In-Reply-To: <20071206163451.GB20595@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Renzo also described something new (in the socket() arena): the 
>> multi-reader, multi-writer is just not available in IP.
>>     
>
> How is that different from a multicast group?
>   

Good question.  I don't know much about multicast IP.  It's a bit new 
for me.  I knew it uses Martian addresses!  After a little reading, I 
now know that it does allow many to many communication.

Renzo's IPN is a local protocol--you can't multicast to localhost.
