Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYIISXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYIISXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIISXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:23:16 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:41049 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYIISXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:23:15 -0400
Message-ID: <1633.69.2.248.210.1220982784.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48C6B3F4.5050406@suse.de>
References: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>  
        <48C60685.60303@suse.de>   
    <1044.69.2.248.210.1220971907.squirrel@webmail.wolfmountaingroup.com>
    <1702.69.2.248.210.1220972366.squirrel@webmail.wolfmountaingroup.com>
    <48C6B3F4.5050406@suse.de>
Date: Tue, 9 Sep 2008 11:53:04 -0600 (MDT)
Subject: Re: 2.6.27-rc5 acpi: EC Storm error message on bootup
From: jmerkey@wolfmountaingroup.com
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> jmerkey@wolfmountaingroup.com wrote:
>> Oh shit, my mistake.  I applied it to a 2.2.26.4 tree.  please
>> disregard.
>> I will test it shortly.
> Thanks!
> I've found more slippery place, could you please add attached patch if the
> first one doesn't work?
>
> Regards,
> Alex.
>

The first patch corrected the problem.  I have regressed the patch on
2.6.27-rc5.  The message is now gone.   I will test the new patch you just
sent later this afternoon (after lunch).

:-)

Jeff

