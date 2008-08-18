Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYHRHFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYHRHFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYHRHFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:05:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52856
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbYHRHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:05:14 -0400
Date: Mon, 18 Aug 2008 00:05:13 -0700 (PDT)
Message-Id: <20080818.000513.224752343.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@mkarcher.dialup.fu-berlin.de
Subject: Re: ath5k text
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A91E12.1060901@gmail.com>
References: <20080817185605.GC30679@tuxdriver.com>
	<20080817.151251.204370966.davem@davemloft.net>
	<48A91E12.1060901@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 18 Aug 2008 09:00:34 +0200

> On 08/18/2008 12:12 AM, David Miller wrote:
> > Their commit messages reference SHA IDs but do not give a commit
> > header line text reference as well.
> > 
> >       ath5k: Don't fiddle with MSI on suspend/resume.
> 
> John, this is it (even if I don't understand the purpose):

The purpose is that when patches are backported or moved to
other GIT trees, the SHA ID is going to be different.

So when you reference just the SHA ID it is not enough
infomration to universally find the commit you are referring
to.

Do you understand "the purpose" now? :-)

