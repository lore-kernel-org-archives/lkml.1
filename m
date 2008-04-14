Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYDNPMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYDNPMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761746AbYDNPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:12:24 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40661 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761725AbYDNPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:12:23 -0400
Date: Mon, 14 Apr 2008 11:12:22 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
Message-ID: <20080414151222.GF7385@csclub.uwaterloo.ca>
References: <47FFD3F3.50107@redhat.com> <821384.64293.qm@web52504.mail.re2.yahoo.com> <20080411213843.GH2160@csclub.uwaterloo.ca> <4802608A.3040901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4802608A.3040901@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 12:35:38PM -0700, H. Peter Anvin wrote:
> "Any machine with spread spectrum clocking" is a pretty outrageous 
> claim, since that includes just about 100% of all machines built today 
> -- it's virtually impossible getting RFI certification without it.

True, but usually they give you an option to turn it off in the BIOS to
make the system actually work with things like NTP.

Maybe I should have said "Any system with spread spectrum enabled".

-- 
Len Sorensen
