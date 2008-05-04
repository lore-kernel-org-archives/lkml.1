Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYEDShJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYEDShJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYEDSgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:36:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:25556 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYEDSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JuY9sKsqtzYCCpLUi6WrmWwI81vYlV2WDbTVtt6tsc65g5/jnWJNfKJXqy9mY4K/f7sxznHe2mItmpVa+/4RIY9mFZ5n1LxmJ8WBxBX6nVJaHbauRJsry8/Mx2F0rPbphajd0GErMX1BZ9UC7AAlb0iHHWkf6w0Nd0ZxsTAFKbk=
Date: Sun, 4 May 2008 22:36:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: x86-64defconfig remake
Message-ID: <20080504183645.GA6926@cvg>
References: <20080504155719.GA6842@cvg> <20080504180642.GA19184@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504180642.GA19184@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, May 04, 2008 at 08:06:42PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > The current x86_64_defconfig contains a number of nonexistent
| > symbols. Lets fix it.
| 
| thanks Cyrill, applied. I also fixed up the 32-bit defconfig and did a 
| few more updates to both of them as well, to make it more generally 
| useful.
| 
| 	Ingo
| 

Thanks Ingo, lets wait for feedback from community ;)
I hope they would not kill us ;)

		- Cyrill -
