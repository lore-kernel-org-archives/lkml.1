Return-Path: <linux-kernel-owner+w=401wt.eu-S937335AbXGMTbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937335AbXGMTbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbXGMTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:31:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357AbXGMTbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:31:44 -0400
Date: Fri, 13 Jul 2007 15:31:38 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
Message-ID: <20070713193138.GA31781@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4697B7DB.3030006@zytor.com> <20070713182739.GE28567@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713182739.GE28567@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 02:27:39PM -0400, Dave Jones wrote:
 > On Fri, Jul 13, 2007 at 10:35:23AM -0700, H. Peter Anvin wrote:
 >  > It causes build failures on i386.
 >  > 
 >  > Yet another case of unnecessary divergence between i386 and x86-64 I'm
 >  > afraid...
 > 
 > Already fixed in cpufreq.git, pull request about to linus.

Sigh. And now its reverted.

Can we be a bit less trigger happy about reverting stuff ?
Linus, how do you want to proceed, cpufreq.git has that fixed, but
will you now have to revert the revert, or will I have to do something?

	Dave

-- 
http://www.codemonkey.org.uk
