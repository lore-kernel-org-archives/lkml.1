Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYKWIJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYKWIJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYKWIJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:09:26 -0500
Received: from fwc.sitour.cz ([62.209.212.18]:2934 "EHLO kali.sitour.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYKWIJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:09:25 -0500
Message-ID: <49290FAD.7060601@mydatex.cz>
Date: Sun, 23 Nov 2008 09:09:17 +0100
From: Daniel Smolik <marvin@mydatex.cz>
Organization: Mydatex s.r.o.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.8.0.14eol) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.13~pre080323b-0etch3)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11886] without serial console system doesn't  poweroff
References: <0kQZaQnNVIL.A.BhG.FwIKJB@chimera> <V2w_GS-X2aE.A.rFH.VwIKJB@chimera>
In-Reply-To: <V2w_GS-X2aE.A.rFH.VwIKJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11886
> Subject		: without serial console system doesn't  poweroff
> Submitter	: Daniel Smolik <marvin@mydatex.cz>
> Date		: 2008-10-29 04:06 (25 days old)
> 
> 
Yes this problem still exists. Lates I test 2.6.27.5. I am in bisecting of patch.

			Dan


