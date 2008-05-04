Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYEDG23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYEDG23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 02:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYEDG2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 02:28:23 -0400
Received: from quechua.inka.de ([193.197.184.2]:35051 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYEDG2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 02:28:22 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080504054044.GA32030@damson>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JsXhq-0006im-00@calista.eckenfels.net>
Date: Sun, 04 May 2008 08:28:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080504054044.GA32030@damson> you wrote:
> (In other words, the number of these has increased significantly since the
> last release, and these will probably be hit as compile errors at one point
> or another.)

In other words this feature is very seldomly used and we could just disallow
to use it. (However I guess it missed some - otherwise we wont have so much
talk about it).

Gruss
Bernd
