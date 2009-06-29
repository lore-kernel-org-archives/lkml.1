Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZF2GbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZF2GbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZF2GbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:31:08 -0400
Received: from fwc.sitour.cz ([62.209.212.18]:4127 "EHLO kali.sitour.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZF2GbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:31:07 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 02:31:07 EDT
Message-ID: <4A485D71.5020204@mydatex.cz>
Date: Mon, 29 Jun 2009 08:21:37 +0200
From: Daniel Smolik <marvin@mydatex.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13512] D43 on 2.6.30 doesn't suspend anymore
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.uzF.njASKB@chimera>
In-Reply-To: <5Hhc7UkUKEO.A.uzF.njASKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. affected napsal(a):
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13512
> Subject		: D43 on 2.6.30 doesn't suspend anymore
> Submitter	: Daniel Smolik <marvin@mydatex.cz>
> Date		: 2009-06-11 20:12 (18 days old)
>
>
>   
Yes problem still exists. I now bitsecting and I am near to find 
affected patch.

Regards
       Dan


