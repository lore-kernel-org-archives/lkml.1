Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZKKJoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZKKJoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZKKJoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:44:23 -0500
Received: from smtp.nokia.com ([192.100.105.134]:65185 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZKKJoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:44:21 -0500
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       ext Tony Lindgren <tony@atomide.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
In-Reply-To: <1257929140.20378.51.camel@tubuntu.research.nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
	 <1257856848.21596.753.camel@localhost>
	 <1257929140.20378.51.camel@tubuntu.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 11:44:01 +0200
Message-ID: <1257932641.20378.77.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2009 09:44:03.0362 (UTC) FILETIME=[80D57020:01CA62B3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 09:45 +0100, Valkeinen Tomi (Nokia-D/Helsinki)
wrote:
> On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> > Tomi,
> > 
> > could you please kindly ask Stephen (CCed) to include the DSS2 tree into
> > linux-next, because you are going to merge it the next merge window, and
> > there does not seem to be any blocker for this.
> > 
> > Being in linux-next for a while is really important.
> 
> Stephen, would this be possible? DSS2 driver is rather big piece of
> code, even if it's quite isolated, so it would be nice to have it in
> linux-next.
> 
> What does it require from me? A git tree, obviously, but what should it
> be based on?

Ah, I just realized that DSS2 patches depend on patches from Tony's
tree. I guess I should base my tree on top of some Tony's tree that is
going to linux-next?

 Tomi


