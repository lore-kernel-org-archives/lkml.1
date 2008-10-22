Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYJVSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYJVSAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYJVSAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:00:23 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:50432 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYJVSAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:00:21 -0400
X-Greylist: delayed 1091 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 14:00:21 EDT
Date: Wed, 22 Oct 2008 10:37:21 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Jouni Malinen <j@w1.fi>,
       Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
Message-ID: <20081022173721.GA5786@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <48FDFCCA.8040604@lwfinger.net> <20081022072840.GD16005@jm.kir.nu> <48FF5933.3080501@lwfinger.net> <1224695189.30459.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224695189.30459.6.camel@johannes.berg>
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jean Tourrilhes <jt@hpl.hp.com>
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jt@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 07:06:29PM +0200, Johannes Berg wrote:
> On Wed, 2008-10-22 at 09:47 -0700, Larry Finger wrote:
> 
> > When a utility starts spitting messages that it doesn't understand what the
> > kernel is providing _AND_ the commit message does not mention that this will
> > happen, can someone be blamed for thinking it is a bug?
> 
> Heh, no, not really. It was fairly obvious us, but I guess we were just
> routine-blinded.
> 
> > Clearly this is not a regression. Are there plans to update the wireless utilities?
> 
> I suspect it could just be made to ignore them. Or skip a select few,
> but obviously it will never be able to parse all of them...
> 
> johannes

	Hi,

	If you want me to understand what it's about, you may want to
give me a bit more context.
	Alternatively, just send me a patch for Wireless Tools, and
I'll put it in the next release. Wireless Tools is still maintained
and I still do releases, even if I don't put much cycles into it.
	Have a great day...

	Jean

