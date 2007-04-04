Return-Path: <linux-kernel-owner+w=401wt.eu-S2992728AbXDDIHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992728AbXDDIHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992729AbXDDIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:07:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:17923 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992728AbXDDIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:07:15 -0400
X-IronPort-AV: i="4.14,369,1170651600"; 
   d="scan'208"; a="33689456:sNHT24325056"
Subject: Re: [PATCH] Blackfin arch: add asm-blackfin socket header files
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: bryan.wu@analog.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1175669730.10608.43.camel@roc-desktop>
References: <1175668088.10608.37.camel@roc-desktop>
	 <1175669730.10608.43.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 16:08:44 +0800
Message-Id: <1175674124.10608.46.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 14:55 +0800, Wu, Bryan wrote:
> On Wed, 2007-04-04 at 14:28 +0800, Wu, Bryan wrote:
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > ---
> >  include/asm-blackfin/socket.h  |   55 ++++++++++++++++++++++++++++++++++++++++
> >  include/asm-blackfin/sockios.h |   13 +++++++++
> >  2 files changed, 68 insertions(+), 0 deletions(-)
> >  create mode 100644 include/asm-blackfin/socket.h
> >  create mode 100644 include/asm-blackfin/sockios.h
> > 
> 
> Maybe we can add generic header files such as
> include/asm-generic/socket.h and include/asm-generic/sockios.h.
> 
> Cheers,
> -Bryan

oops, I screwed up the patch set in my local git-tree. please drop this
patch and I will send a new one.

Sorry for this.
-Bryan
