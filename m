Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYDML5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYDML5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYDML5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 07:57:42 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:43103 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752934AbYDML5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 07:57:41 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 21:57:31 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Remember the message level for multi-line	output
Message-ID: <20080413115731.GF29599@tull.net>
References: <20080412161733.24882.30930.stgit@marcab.local.tull.net> <20080413074007.GE20332@elte.hu> <20080413113453.GE29599@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413113453.GE29599@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 09:34:53PM +1000, Nick Andrew wrote:
> On Sun, Apr 13, 2008 at 09:40:07AM +0200, Ingo Molnar wrote:
> > so how about splitting it into two, first the code restructuring then a 
> > small add-on that does your feature? Does this make sense to you? This 
> > way, even if the feature ends up not being applied, we'll have your nice 
> > cleanup :-)
> 
> Can do.

lkml: I posted a 2-part patch and forgot to set the References, so it's in a
new thread now.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
