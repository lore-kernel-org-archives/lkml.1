Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZILNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZILNjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 09:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZILNjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 09:39:35 -0400
Received: from vena.lwn.net ([206.168.112.25]:58258 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbZILNjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 09:39:35 -0400
Date: Sat, 12 Sep 2009 07:39:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] docs tree
Message-ID: <20090912073937.75b33db8@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

There's a couple of patches in my docs tree - one fix and one new
document.  The flex_array doc looks to be rendered quickly dated by
pending changes, but I hereby solemnly swear to update it when that
happens.

  git://git.lwn.net/linux-2.6.git docs-next

Jesper Dangaard Brouer (1):
      Doc: seq_file.txt fix wrong dd command example.

Jonathan Corbet (1):
      Document the flex_array library.

 Documentation/filesystems/seq_file.txt |    2 +-
 Documentation/flexible-arrays.txt      |   99 ++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/flexible-arrays.txt

Thanks,

jon
