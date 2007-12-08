Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbXLHRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbXLHRZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXLHRZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:25:10 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:57526 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXLHRZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:25:08 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Sat, 8 Dec 2007 16:54:19 +0100
User-Agent: KMail/1.9.7
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712081312.14726.M4rkusXXL@web.de> <20071208150637.4eee3e3d@localhost>
In-Reply-To: <20071208150637.4eee3e3d@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712081654.20211.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+ivpPlEaAygp77T+AxfsaMILCm9Ipc1kxJfzNT
	bQDhTfv2qpAlv3Id3nFEmloIiSIKYiypryWgfacEpjJJQKVpDX
	dokhKG9Io=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, no I am not the same markus. And I found that before, but I 
thought it was something about cfs and imo that made it into linus-tree 
in .23 not .22.
But I should perhaps try to change my name, perhaps that fixes it -.-

Markus

PS: am currently doing a bisect, thats really bad: third bisect and the 
kernel is unusable.

> On Sat, 8 Dec 2007 13:12:14 +0100
> Markus <M4rkusXXL@web.de> wrote:
> 
> > I try that, but it will take a lot of time!
> > 
> > Markus
> 
> This problem remembers me something...
> 
> 
http://groups.google.com/group/linux.kernel/browse_thread/thread/85859519ffec7dc8/591a0b3a05bd3596?lnk=gst&q=konqueror+vanish#591a0b3a05bd3596
> 
> 
> Are you the same Markus? (or it's just a coincidence?)
> 
> It seems the same BUG...
