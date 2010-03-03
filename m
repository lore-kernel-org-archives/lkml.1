Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0CCAQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:16:18 -0500
Received: from zimbra.ccs.neu.edu ([129.10.116.59]:36826 "EHLO
	zimbra.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0CCAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:16:16 -0500
Date: Tue, 2 Mar 2010 19:16:08 -0500 (EST)
From: Ari Entlich <atrigent@ccs.neu.edu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <11363741.318021267575368900.JavaMail.root@zimbra>
In-Reply-To: <9842632.318001267575211703.JavaMail.root@zimbra>
Subject: Re: [PATCH 34/36] tty: Add a new VT mode which is like VT_PROCESS
 but doesn't require a VT_RELDISP ioctl call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.241.22.119]
X-Mailer: Zimbra 5.0.22_GA_3210.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.22_GA_3210.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Greg KH" <gregkh@suse.de> wrote:
> Hm, it's been there for over a week from what I can tell, right?

Hmm yes, I suppose it has.

> I'll revert it after this batch goes into Linus's tree.  Next time, warn
> me a bit earlier :)

I apologize; I would have if I had realized that you picking it up meant it
was on its way to mainline.

Ari
