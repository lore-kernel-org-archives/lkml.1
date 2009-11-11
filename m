Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZKKIqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZKKIqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZKKIqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:46:10 -0500
Received: from smtp.nokia.com ([192.100.105.134]:59589 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZKKIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:46:09 -0500
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
In-Reply-To: <1257856848.21596.753.camel@localhost>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
	 <1257856848.21596.753.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 10:45:40 +0200
Message-ID: <1257929140.20378.51.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2009 08:45:43.0383 (UTC) FILETIME=[5AAF0670:01CA62AB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> Tomi,
> 
> could you please kindly ask Stephen (CCed) to include the DSS2 tree into
> linux-next, because you are going to merge it the next merge window, and
> there does not seem to be any blocker for this.
> 
> Being in linux-next for a while is really important.

Stephen, would this be possible? DSS2 driver is rather big piece of
code, even if it's quite isolated, so it would be nice to have it in
linux-next.

What does it require from me? A git tree, obviously, but what should it
be based on?

 Tomi


