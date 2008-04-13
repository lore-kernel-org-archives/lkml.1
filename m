Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYDMTg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYDMTg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYDMTgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:36:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYDMTgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:36:18 -0400
Message-ID: <4802608A.3040901@zytor.com>
Date: Sun, 13 Apr 2008 12:35:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <47FFD3F3.50107@redhat.com> <821384.64293.qm@web52504.mail.re2.yahoo.com> <20080411213843.GH2160@csclub.uwaterloo.ca>
In-Reply-To: <20080411213843.GH2160@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> 
> I have found that ntp tends to fail to work on any machine with spread
> spectrum clocking enabled.  On those machines disabling spread specturm
> in the BIOS seems to fix it.  I had to update the BIOS on one machine to
> even get the option to disable it though.
> 

"Any machine with spread spectrum clocking" is a pretty outrageous 
claim, since that includes just about 100% of all machines built today 
-- it's virtually impossible getting RFI certification without it.

	-hpa
