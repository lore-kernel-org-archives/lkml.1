Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbZGGAbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbZGGAbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbZGGAag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:30:36 -0400
Received: from xdsl-87-78-234-110.netcologne.de ([87.78.234.110]:43263 "EHLO
	horst.phuk.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbZGGAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:30:34 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 20:30:33 EDT
Message-ID: <4A52952C.1060006@phuk.ath.cx>
Date: Tue, 07 Jul 2009 02:22:04 +0200
From: list@phuk.ath.cx
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #13624] usb: wrong autosuspend initialization
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.NAH.HApUKB@chimera>
In-Reply-To: <bXZeuxPQAWE.A.NAH.HApUKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this should be considered a regression, at least until 
laptop_mode has been fixed to deal with it. I've reported it to their 
mailing list, but it seems somebody has to come up with a patch (I won't 
be able to look into it before mid-August).

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13624
> Subject		: usb: wrong autosuspend initialization
> Submitter	:  <list@phuk.ath.cx>
> Date		: 2009-06-25 18:18 (12 days old)
> 
> 

