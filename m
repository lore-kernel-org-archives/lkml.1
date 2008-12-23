Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYLWXYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYLWXYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 18:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYLWXX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 18:23:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:26713 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395AbYLWXX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 18:23:57 -0500
Message-ID: <49517305.4000100@ru.mvista.com>
Date: Wed, 24 Dec 2008 02:23:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: gregkh@suse.de, felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       khilman@deeprootsystems.com,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] musb: fix DaVinci build again
References: <200812072341.50012.sshtylyov@ru.mvista.com> <494E2450.9080601@ru.mvista.com> <4950CFAD.7020403@ru.mvista.com> <200812230939.00508.david-b@pacbell.net>
In-Reply-To: <200812230939.00508.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Brownell wrote:

>>    For how much longer we'll have to wait for this issue to be resolved? 
>> 2.6.28 is 2 days away (at most).
>>     
>
> Yeah, I sent a DaVinci build fix patch in plenty of time to
> be merged for *2.6.27* (!!!!) but still the key parts are
> missing, and have not managed to make it into mainline.

  Try breakinjg the patches into smaller pieces next time, so they may 
get thru the maintainer's sieve more easily. :-)

WBR, Sergei


