Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbXIVG16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbXIVG16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXIVG1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:27:51 -0400
Received: from fallback.mail.ru ([194.67.57.14]:11590 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXIVG1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:27:50 -0400
Date: Fri, 21 Sep 2007 01:38:24 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] missing null termination in power supply uevent
Message-ID: <20070920213824.GA1624@zarina>
Reply-To: cbou@mail.ru
References: <20070920190608.339749785@linux-foundation.org> <20070920190627.619372296@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070920190627.619372296@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:06:10PM -0700, Stephen Hemminger wrote:
> Need to null terminate environment. Found by inspection
> while looking for similar problems to platform uevent bug
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Much thanks, git-applymbox'ed to battery-2.6.git. I suppose this is
serious enough, thus should hit 2.6.23.

Though prior asking to pull I'll wait just a bit.

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
