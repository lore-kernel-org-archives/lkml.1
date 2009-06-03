Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZFCPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZFCPik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZFCPib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:38:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:37980 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbZFCPia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:38:30 -0400
To: Markus <M4rkusXXL@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Seagate Barracuda 7200.11 ST31500341AS fw SD17
References: <200906021258.20346.M4rkusXXL@web.de>
	<200906021438.50228.M4rkusXXL@web.de>
	<m3r5y2ivh6.fsf@intrepid.localdomain>
	<200906031214.39610.M4rkusXXL@web.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 03 Jun 2009 17:38:30 +0200
In-Reply-To: <200906031214.39610.M4rkusXXL@web.de> (Markus's message of "Wed\, 3 Jun 2009 12\:14\:39 +0200")
Message-ID: <m3ab4pba4p.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus <M4rkusXXL@web.de> writes:

>> > I tried that one (compared md5sum). It does not work. It only works 
>> > for "ST31500341AS,  9JU138-300 or -336, SD15 through SD1A ONLY!"
>
> Of course I did. They told me, my drives are not affected and drives 
> with "good" serial numbers will not be upgraded.
> And they now told me I have OEM drives (???) which they do not provide 
> firmware upgrades for, although my drives are ok. I dont understand 
> those support-people.

Well, they might be right. Or the drives may be affected but they don't
support OEM versions anyway and may not know.

Obviously one could try updating anyway (I'm sure a simple hack in
version/SN checking routine would do). It may be risky.
You should, in theory, contact the OEM partner, not the manufacturer.
Could be hard.

OTOH I think the update fixes unrelated problem (a drives failing to
start), that would need checking.
-- 
Krzysztof Halasa
