Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZHLQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZHLQCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZHLQCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:02:17 -0400
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:44735 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754097AbZHLQCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:02:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KLcdQgC/vqmtRUc2GYSCzsaHYQ+oGsO9SOh8oLw4HD8WDGqiZihHzKjjfPXJ5gkoMdcIaa8B4SUWB1W/PIeG5gUJ2FJz7tNCBC/hOctCQKXwGiIvo0pXAV8grF1yIkQO;
Date: Wed, 12 Aug 2009 09:02:14 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tiago.vignatti@nokia.com
Cc: Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090812090214.2f5d3c4a@jbarnes-g45>
In-Reply-To: <20090812073516.GB6453@cachaca>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
	<20090811161746.7b8878aa@jbarnes-g45>
	<20090811162103.1b2a65c9@jbarnes-g45>
	<20090812073516.GB6453@cachaca>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009 10:35:16 +0300
"Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com> wrote:

> On Wed, Aug 12, 2009 at 01:21:03AM +0200, Jesse Barnes wrote:
> > Oh yeah, and we should get the documentation merged too.  I can
> > handle that or you can send it to Randy.  Tiago?
> 
> Okay, I can handle this documentation pretty easy. 
> 
> But honestly I'm not sure we (or some future developer) will use it.
> The header (include/linux/vgaarb.h) is already very nice documented.
> So, tell me what do you think Jesse.

As long as it's still accurate we may as well include it.

-- 
Jesse Barnes, Intel Open Source Technology Center
