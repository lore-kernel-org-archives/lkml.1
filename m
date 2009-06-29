Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZF2PCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZF2PCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758862AbZF2PCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:02:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36258 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZF2PCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y4zFjvbUH46pnDbXdnLTC5KKPkQKlyFsFuKZ7FO4OrB2NLL5/+42uPhc2ABR04SRJP
         8yl91zFSRhhzLw5A1q+1XNKoYA9urag9xiH9nty7tRYx4rKe4FzNIC4ZqqXSjH7UAgyf
         X/8cCLfuHNcwdebZwcDHa1LxUHcqvnR9emOgI=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, slapin@ossfans.org
Subject: [GIT PULL] Fixes for the IEEE 802.15.4 code
Date: Mon, 29 Jun 2009 19:02:12 +0400
Message-Id: <1246287735-2692-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull three following patches, containing small fixes for the IEEE 802.15.4
code. The branch is based against net-next/master. Thank you.

The following changes since commit 28d0325ce6e0a52f53d8af687e6427fee59004d3:
  Linus Torvalds (1):
        Linux 2.6.31-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git for-linus

Dmitry Eremin-Solenikov (3):
      MAINTAINERS: ieee802154 lists are moderated for non-subscribers.
      nl802154: fix Oops in ieee802154_nl_get_dev
      nl802154: add module license and description

 MAINTAINERS              |    2 +-
 net/ieee802154/netlink.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

