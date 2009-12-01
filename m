Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbZLAQVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbZLAQVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZLAQVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:21:40 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:56076 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZLAQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:21:39 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Tue, 1 Dec 2009 16:21:42 +0000
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-1.csi.cam.ac.uk
To: Michal Marek <mmarek@suse.cz>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCHv2] unifdef: update to upstream revision 1.190
In-Reply-To: <4B15406D.6010800@suse.cz>
Message-ID: <alpine.LSU.2.00.0912011615210.3461@hermes-1.csi.cam.ac.uk>
References: <4B151704.7020102@suse.cz>    <20091127210408.GA16310@merkur.ravnborg.org>    <E1NE3M6-0003Za-OJ@hermes-1.csi.cam.ac.uk>    <20091127181749.GA16177@merkur.ravnborg.org>    <alpine.LSU.2.00.0911271901430.6581@hermes-1.csi.cam.ac.uk>
 <E1NFU0t-0002UG-0R@hermes-1.csi.cam.ac.uk> <4B15406D.6010800@suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Michal Marek wrote:
>
> Thanks, applied.

Thank you.

> BTW, scripts/checkpatch.pl reports some coding style issues (mostly
> parentheses in return statements and opening braces directly after
> function declarations), but as this is not original kernel source but a
> copy of one file from another project, I think we should be lenient
> here.

Sorry, I should have explicitly noted that the existing style deviations
were not fixed by the update to the latest version.

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
GERMAN BIGHT HUMBER: SOUTHWEST 5 TO 7. MODERATE OR ROUGH. SQUALLY SHOWERS.
MODERATE OR GOOD.
