Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZCDJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZCDJah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZCDJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:30:28 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58380 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCDJa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:30:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o/YRQODepfcSYx62dVrwlXSaxBBonVmJCFtdnIAqNkVAZMfELDUV1j6j+Ei9rgQ9IJ
         XeyCkiCX5NjvAVW5VxhzfDcbaDhgo4+usa/lie6qAeEybz+Z425DP2zh1FT6KJkQoXBi
         eP9pITUmyGiBrcfn53oJ4Z+Cgs1KpH91R/Nsg=
Message-ID: <49AE4A2E.8090300@gmail.com>
Date: Wed, 04 Mar 2009 10:30:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hid-dummy.ko Input/output error -- causing huge delays
References: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com>	 <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>	 <49AD17DD.1030206@gmail.com>	 <43e72e890903031607k4e2ce36csb7c48de2f01a6de6@mail.gmail.com> <43e72e890903031738w12a726d4ga3f998d8e4263a73@mail.gmail.com>
In-Reply-To: <43e72e890903031738w12a726d4ga3f998d8e4263a73@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.3.2009 02:38, Luis R. Rodriguez wrote:
> Well now I see FC10 say its starting udev and it just sits there
> waiting for the same period of time so maybe it was that (?). But at
> the console the hid-dummy is not the last message I see now, but I
> guess I wouldn't because it returns 0 now huh.

Sorry, I'm totally confused now :). What you wouldn't?

Actually I saw similar behavior on one of my boxes. I'll recheck if it 
is still present.

Thanks so far.
