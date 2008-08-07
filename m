Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYHGAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYHGAIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYHGAE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:04:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:44190 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbYHGAE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:04:28 -0400
Date: Thu, 7 Aug 2008 10:04:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Wagner <daw@cs.berkeley.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
In-Reply-To: <g7d8a1$81o$2@taverner.cs.berkeley.edu>
Message-ID: <alpine.LRH.1.10.0808070951550.15561@tundra.namei.org>
References: <20080805225524.GB4006@fieldses.org> <20080806101028.B87BA2FE88B@pmx1.sophos.com> <g7d8a1$81o$2@taverner.cs.berkeley.edu>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, David Wagner wrote:

> As I recall, the basic stats looked like this: about 30% of zero-day 
> malware samples
> were detected on the first day they were released (and 70% weren't).
> The median number of days until a new malware sample was detected was
> about 40 days.  If you wanted hundreds of days, asymptotically McAfee was
> able to detect about 70% of the samples (and 30% were never detected).
> I expect the situation to get worse in the future, not better.

This is similar to the stats published by AusCert a couple of years back 
where they claimed that AV software failed to detect 80% of new malware:

<http://www.zdnet.com.au/news/security/soa/Eighty-percent-of-new-malware-defeats-antivirus/0,130061744,139263949,00.htm>

Interestingly, AusCert still describe up-to-date anti-virus software as 
being "essential", per http://www.auscert.org.au/render.html?it=6891

In any case, the above relates to Windows desktops -- we are yet to see 
a rationale for adding AV support to the Linux kernel.


- James
-- 
James Morris
<jmorris@namei.org>
