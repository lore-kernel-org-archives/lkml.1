Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0BACB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 21:01:26 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:41764 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab0BACBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 21:01:24 -0500
Message-ID: <4B6635F1.8060909@blueyonder.co.uk>
Date: Mon, 01 Feb 2010 02:01:21 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #15144] HDA Intel Audio hang on boot
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <d3IDKWHT5gE.A.MEC.a7hZLB@chimera>
In-Reply-To: <d3IDKWHT5gE.A.MEC.a7hZLB@chimera>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/10 00:22, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
> Subject		: HDA Intel Audio hang on boot
> Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
> Date		: 2010-01-15 1:24 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4
> 
> 
> 

Still not fixed in 2.6.33-rc6. Takashi wrote that the fix was scheduled
for 2.6.33-rc6, but it did not appear. I have gone back to using the
workaround with 2.6.33-rc6.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

