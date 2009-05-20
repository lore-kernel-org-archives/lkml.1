Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZETIQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZETIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZETIQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:16:40 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:53869 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756236AbZETIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:16:39 -0400
Message-ID: <4A13BC50.4010705@euromail.se>
Date: Wed, 20 May 2009 10:16:16 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Augment the event semantics documentation
References: <1242593479-9238-1-git-send-email-rydberg@euromail.se> <1242593479-9238-2-git-send-email-rydberg@euromail.se> <20090520025957.GE17649@dtor-d630.eng.vmware.com>
In-Reply-To: <20090520025957.GE17649@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.133.150
X-Scan-Result: No virus found in message 1M6gyW-0006pQ-3m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1M6gyW-0006pQ-3m 1cfd2c80ef9f0a4e83a4c46e34a83976
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Sun, May 17, 2009 at 10:51:19PM +0200, Henrik Rydberg wrote:
>> Through the collaboration to adapt the N-trig and Stantum HID
>> drivers to the MT protocol, some semantic clarifications to the
>> protocol have been made. This patch adds them to the MT documentation.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> Tested-by: Stéphane Chatty <chatty@enac.fr>
> 
> I was wondering if the following changes would not make the text a bit
> better:

They do, thanks. I got more comments on the text, perhaps it is easiest
if I send an additional patch on top of this one, with your changes
included? It seems folding a patch is easier than to find out what
changes were made to the changes.

Cheers,
Henrik

