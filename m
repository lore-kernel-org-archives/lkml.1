Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYIIP3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYIIP3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYIIP3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:29:36 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50824 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYIIP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:29:35 -0400
Message-ID: <1702.69.2.248.210.1220972366.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1044.69.2.248.210.1220971907.squirrel@webmail.wolfmountaingroup.com>
References: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>  
     <48C60685.60303@suse.de>
    <1044.69.2.248.210.1220971907.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 9 Sep 2008 08:59:26 -0600 (MDT)
Subject: Re: 2.6.27-rc5 acpi: EC Storm error message on bootup
From: jmerkey@wolfmountaingroup.com
To: jmerkey@wolfmountaingroup.com
Cc: "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It does not disable EC, it disables EC GPE (interrupt from EC).
>> Could you please test patch from comment #81 in bug #9998?
>> http://bugzilla.kernel.org/attachment.cgi?id=17695&action=view
>>
>> Thanks,
>> Alex.
>
> Patch does not apply correctly to 2.6.27-rc5 -- do you have a patch a
> little closer to 2.6.27-rc6?
>
> Here is what ended up in the .rej file after I applied it:
>
> Jeff
>
>

Oh shit, my mistake.  I applied it to a 2.2.26.4 tree.  please disregard. 
I will test it shortly.

Jeff

