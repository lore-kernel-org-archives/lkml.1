Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXETITW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXETITW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 04:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbXETITO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 04:19:14 -0400
Received: from dedi.luli.de ([88.198.62.74]:35378 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbXETITN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 04:19:13 -0400
Message-ID: <4650047F.4000804@rootdir.de>
Date: Sun, 20 May 2007 10:19:11 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Christian Volkmann <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: Via C3/C7: other flags possible ?
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <464F332C.8060904@rootdir.de> <464F5C8F.5000304@cv-sv.de> <464F7C09.8060809@cv-sv.de> <464F7F90.2000900@simon.arlott.org.uk>
In-Reply-To: <464F7F90.2000900@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott schrieb:
> On 19/05/07 23:36, Christian Volkmann wrote:
>> Christian Volkmann wrote:
>>> Claas asked for the NX flag for the Via C3 (?) processors
>>> in another thread.
>
> If you read the other thread properly you'd see that the BIOS has an 
> option to enable or disable it... when enabled it shows up.

Right, but my bios disables this after each boot-time :(
Therefore it would be great if the kernel would not care
about the BIOS and enable it anyway.

This seems to be a severe bug in the BIOS, but VIA does not
deliver a new BIOS since months. :(

>
> I can't reboot that box just to test cx8 detection (which is missing).
>
It works here.



claas
