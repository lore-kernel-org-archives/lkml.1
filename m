Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXJCFjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXJCFjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbXJCFi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:38:58 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:45033 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751851AbXJCFi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:38:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 01:38:56 EDT
Message-ID: <4703295E.8010608@crispincowan.com>
Date: Tue, 02 Oct 2007 22:32:14 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>  <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Security, on the other hand, very much does depend on the circumstances 
> and the wishes of the users (or policy-makers). And if we had one module 
> that everybody would be happy with, I'd not make it pluggable either. But 
> as it is, we _know_ that's not the case. 
>   
And you claim you are not a security expert :-)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

