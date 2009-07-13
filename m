Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZGMPT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZGMPT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZGMPTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:17 -0400
Received: from ru.mvista.com ([213.79.90.228]:62967 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756171AbZGMPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:15 -0400
Date: Mon, 13 Jul 2009 19:19:11 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been sitting on these patches for some time, but now it appears
that the set_sync() feature is needed elsewhere. So here are the
patches.

Joakim, I think this is what you need.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
