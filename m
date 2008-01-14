Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbYANP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbYANP2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYANP2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:28:42 -0500
Received: from smtp-03.mandic.com.br ([200.225.81.143]:50306 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYANP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:28:41 -0500
Message-ID: <478B7F9F.3020209@mandic.com.br>
Date: Mon, 14 Jan 2008 13:28:31 -0200
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Updatedb hangs Kernel 2.6.22.9-cfs-v22
References: <478900FF.2000706@mandic.com.br> <2c0942db0801121025h7f22d716s657af75ce7603af0@mail.gmail.com>
In-Reply-To: <2c0942db0801121025h7f22d716s657af75ce7603af0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee escreveu:
> On Jan 12, 2008 10:03 AM, Renato S. Yamane wrote:
>> I can't use updatedb in Debian Etch (stable) using customized Kernel
>> 2.6.22.9-cfs-v22.
>>
>> When I ran updatedb, after ~1 minute my system hangs and "caps lock" LED
>> is blinking. No log is registered.
> 
> Please switch out of X11 to a text mode console (CTRL-ALT-F1), and run
> updatedb there. Capture the oops with a digital camera, and post a
> link to the picture (not the picture itself!) to the list. Or, write
> down the oops carefully, and post the text.

I see a infinite loop and is very fast, so I can't capture errors messages.
None is registered in /var/log/*

Regards,
Renato
