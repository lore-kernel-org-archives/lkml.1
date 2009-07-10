Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZGJJyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZGJJyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZGJJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:54:37 -0400
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:48649 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbZGJJyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:54:37 -0400
Date: Fri, 10 Jul 2009 11:54:32 +0200
From: Dick Streefland <dick@streefland.net>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090710095432.GA9721@streefland.net>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com> <20090629113613.GA6853@streefland.net> <20090709023855.GA5648@cr0.nay.redhat.com> <20090709082651.GA6165@streefland.net> <20090710075530.GB6263@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710075530.GB6263@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1MPCoL-0008RR-J3
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.322, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60, TW_IK 0.08)
X-ZiggoSMTP-MailScanner-From: dick@streefland.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2009-07-10 15:55, Amerigo Wang wrote:
| Have you checked other version of grep? I mean lower version, of course,
| does your script work with them too?

The script works with all grep versions since 2.5, released 2002-03-13,
where the -o option was added. The config extraction feature was
introduced in Linux 2.6.8, released 2004-08-14, so I don't think this
dependency will be a problem.

-- 
Dick
