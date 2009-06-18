Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbZFRORX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbZFRORX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbZFRORE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:17:04 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:38822 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZFRORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XGRbKGEZO1sPruQ/a029p0j8GXvaNtBnpc/RV/mXv2TrzXiBpdbosph7hte7LFlHPk
         geLMYWOj0ByRZq9nMXbteGjEVFb8NgpyPr20h/tRoJfVBIgZoFEUPb19a08cOHCTX7Ir
         e3JFw6TzSaiC/nqrDkabSNJYxQL8HrfQMYW8Y=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, slapin@ossfans.org
Subject: [GIT PULL] Please pull two IEEE 802.15.4 patches.
Date: Thu, 18 Jun 2009 18:16:45 +0400
Message-Id: <1245334607-16046-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 81e2a3d5b75cbf0b42428b9d5a7cc7c85be9e7a7:
  Eric Dumazet (1):
        atm: sk_wmem_alloc initial value is one

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git for-linus

Dmitry Eremin-Solenikov (2):
      ieee802154: use standard routine for printing dumps
      MAINTAINERS: fix IEEE 802.15.4 entry

 MAINTAINERS                    |    4 ++--
 net/ieee802154/af_ieee802154.c |   12 +++---------
 2 files changed, 5 insertions(+), 11 deletions(-)
