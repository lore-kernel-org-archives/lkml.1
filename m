Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYGJHtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYGJHtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYGJHtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:49:25 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:40778 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYGJHtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:49:25 -0400
X-Greylist: delayed 1713 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 03:49:25 EDT
Date: Thu, 10 Jul 2008 09:20:37 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: "Shaun R." <mailinglists@unix-scripts.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel, 32bit OS?
Message-ID: <20080710072037.GA10883@citd.de>
References: <g53keq$vq1$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g53keq$vq1$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.07.2008 17:16, Shaun R. wrote:
> If i where to run a 32bit OS on a 64bit kernel would there be any 
> problems with that?  I'm not trying to convert the OS to 64bit, just 
> would rather not have to build multiple kernels if i dont have too.  I'm 
> talking x86_32 and x86_64 btw too.

I guess you mean 32bit userspace with a 64bit kernel.

And that's no problem as long as "CONFIG_IA32_EMULATION" is set
The option is in the menu: Executable file formats / Emulations
and is called: IA32 Emulation





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

