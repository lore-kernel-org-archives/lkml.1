Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZCYIGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZCYIGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCYIFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:05:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:25002 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZCYIFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:05:41 -0400
Message-ID: <49C9E5D1.8060900@nokia.com>
Date: Wed, 25 Mar 2009 10:05:37 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible
 with 1.2
References: <49C8CE1B.7000802@nokia.com> <20090324211037.65cd05ea@mjolnir.ossman.eu>
In-Reply-To: <20090324211037.65cd05ea@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 08:04:49.0808 (UTC) FILETIME=[5ED0F100:01C9AD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 24 Mar 2009 14:12:11 +0200
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
>> From a939998e34cbc263317d51b21ab52c8d5863a913 Mon Sep 17 00:00:00 2001
>> From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
>> Date: Thu, 27 Nov 2008 14:30:32 +0200
>> Subject: MMC: Accept EXT_CSD rev 1.3 assuming it is backwards compatible with 1.2
>>
>> Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
>> ---
> 
> I don't like the whole "assuming" part. Do the specs back this up?
> 
> Rgds

Yes.

Please swap "assuming" for "because".
