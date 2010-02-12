Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0BLV6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:58:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32920 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab0BLV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:58:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=uTOmaDeAZlAA:10 a=7U3hwN5JcxgA:10 a=8hnYY6DCsfy3FmPy5F8A:9 a=YbiId30D0xWZ4hPpmgwuxSxe2h4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20100212202534.GH11239@parisc-linux.org>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare> <4B75A5FE.8020408@zytor.com>
	 <20100212202534.GH11239@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Feb 2010 16:58:39 -0500
Message-ID: <1266011919.24271.95.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 13:25 -0700, Matthew Wilcox wrote:

> > It might open up the question if we shouldn't just do a Solaris and drop
> > the leading 2 (so the next kernel would be 6.33) or call the kernel
> > after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.
> 
> Damn, we forgot to have that fight at Kernel Summit last year.
> 
> I'm in favour of the 3.0 / 3.1 / 3.2 with stable@ being responsible for
> 3.0.1, 3.0.2, 3.1.1, etc.
> 

At last years LinuxCon conference, I was practically bouncing out of my
chair wanting to ask Linus about 3.0 in front of everyone while he was
on the panel discussion. But James Bottomley refused to take my
question.

-- Steve


