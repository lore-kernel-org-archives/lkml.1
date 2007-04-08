Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXDHTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXDHTX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXDHTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 15:23:29 -0400
Received: from mail1.skjellin.no ([80.239.42.67]:58307 "EHLO mx1.skjellin.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbXDHTX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 15:23:28 -0400
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 15:23:28 EDT
Message-ID: <46193C50.20100@tomt.net>
Date: Sun, 08 Apr 2007 21:02:40 +0200
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0b2 (Windows/20070116)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.5
References: <20070406184208.GR10574@sequoia.sous-sol.org>
In-Reply-To: <20070406184208.GR10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
<snip snip>
> Arnaldo Carvalho de Melo (1):
>       DCCP: Fix exploitable hole in DCCP socket options
<snip snip>

Does this fix cure CVE-2007-1730 and CVE-2007-1734, or just one of them? 
They both seem to be in the exact same code path the patch touches.
