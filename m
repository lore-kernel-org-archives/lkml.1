Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbYESP3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbYESP3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760719AbYESP2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:28:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:14402 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761160AbYESP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bZ8WIghKL2ToDA7NKOA1sSK9cqQ6YwzBdkNNtmGaJG7tEPh/DSUUq0ksI9IEez6FZsJF6oAgzA1f0hW+pozelU+tTDbFNsl4xGN4d5kHijnk8gZ2L64AGhWDGwffaXBXyveziwQ1q1K6vJ7NFBd9hKPjiOPTGWMT1NkxOzu1rss=
Message-ID: <48319C8E.4030203@gmail.com>
Date: Mon, 19 May 2008 17:28:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] ip2: Fix crashes on load/unload
References: <20080519132053.578.45185.stgit@core> <48319C70.9000207@gmail.com>
In-Reply-To: <48319C70.9000207@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2008 05:27 PM, Jiri Slaby wrote:
> On 05/19/2008 03:20 PM, Alan Cox wrote:
>> From: Alan Cox <alan@redhat.com>
>>
>> This doesn't need to be two modules, and making it one cleans up the
>> problem
>> ---
>>
> 
> Seems OK, but all your patches misses S-O-F line...

s/S-O-F/S-O-B
