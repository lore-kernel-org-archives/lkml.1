Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYFMSji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYFMSji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYFMSj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:39:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:39806 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYFMSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:39:27 -0400
Message-ID: <1213382367.4852bedf43924@213.133.104.17>
Date: Fri, 13 Jun 2008 20:39:27 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 12
References: <20080612175307.8e4e3e08.sfr@canb.auug.org.au> <1213386991.3455.9.camel@dhcppc4> <s5h63sdqjeq.wl%tiwai@suse.de>
In-Reply-To: <s5h63sdqjeq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.45.213
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Takashi Iwai <tiwai@suse.de>:

> It was harmless for Intel and ATI hardwares :)
> We've not tested NVidia ones.  Good that you caught it fast.
> 
> Could you check whether another value, e.g. bdl_pos_adj=32 works?

Yes, indeed. bdl_pos_adj=32 works, too.

Thanks for the quick response.

greets
thomas
