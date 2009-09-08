Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZIHLa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZIHLa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZIHLa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:30:27 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:51550 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbZIHLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:30:26 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 49D023329C9
Message-ID: <4AA64052.4020509@arcor.de>
Date: Tue, 08 Sep 2009 14:30:26 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <200909071754.28675.tfjellstrom@shaw.ca>
In-Reply-To: <200909071754.28675.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 02:54 AM, Thomas Fjellstrom wrote:
> On Sun September 6 2009, Nikos Chantziaras wrote:
>>  [...]
>> For reference, my system is:
>>
>> CPU: Intel Core 2 Duo E6600 (2.4GHz)
>> Mainboard: Asus P5E (Intel X38 chipset)
>> RAM: 6GB (2+2+1+1) dual channel DDR2 800
>> GPU: RV770 (Radeon HD4870).
>>
>
> My Phenom 9550 (2.2Ghz) whips the pants off my Intel Q6600 (2.6Ghz). I and a
> friend of mine both get large amounts of stalling when doing a lot of IO. I
> haven't seen such horrible desktop interactivity since before the new
> schedulers and the -ck patchset came out for 2.4.x. Its a heck of a lot better
> on my AMD Phenom's, but some lag is noticeable these days, even when it wasn't
> a few kernel releases ago.

It seems someone tried BFS on quite slower hardware: Android.  According 
to the feedback, the device is much more responsive with BFS: 
http://twitter.com/cyanogen
