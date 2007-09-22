Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXIVUIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXIVUIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXIVUHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:07:53 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2533 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbXIVUHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:07:53 -0400
Date: Sat, 22 Sep 2007 15:57:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Paul Rolland =?utf-8?B?KOODneODvOODq+ODu+ODreODqeODsyk=?= 
	<rol@witbe.net>
Cc: Rob Hussey <robjhussey@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6 : crash with RTL8187 USB
Message-ID: <20070922195731.GB22629@tuxdriver.com>
References: <20070915131656.4cddab33@tux.DEF.witbe.net> <6b8cef970709150921s48488096wa8089d8d9f5d28bf@mail.gmail.com> <20070922164528.0bb66335@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070922164528.0bb66335@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 04:45:28PM +0200, Paul Rolland (ポール・ロラン) wrote:
> Hello,
> 
> > [PATCH] mac80211: fix initialisation when built-in
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/5710/match=patch+mac80211+initialisation
> > 
> > [PATCH] cfg80211: fix initialisation if built-in
> > http://article.gmane.org/gmane.linux.network/71326/match=patch+cfg80211+initialisation
> 
> This is not present in 2.6.23-rc7 ! :(((

I asked Dave M. to pull it a week ago, and I sent a reminder today.
Hopefully that will take care of it.

John
-- 
John W. Linville
linville@tuxdriver.com
