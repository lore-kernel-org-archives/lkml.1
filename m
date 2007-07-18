Return-Path: <linux-kernel-owner+w=401wt.eu-S935883AbXGRXZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935883AbXGRXZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935504AbXGRXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:24:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34753 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934948AbXGRXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:24:50 -0400
Date: Wed, 18 Jul 2007 16:23:46 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Documentation patches for 2.6.22
Message-ID: <20070718232346.GB4620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches that add some translations of some procedural
documentation files to the Documentation/ tree.

I know that kernel development is in English, but translations of a
small subset of documentation files that go over procedures and how to
get involved in the community is something that I feel is important and
will bring in more developers in the end.  Having these files in the
kernel tree is a good way to keep a central location that all can see
and easily find, instead of hiding them away on different web sites that
might be harder to update by anyone who needs to do so.

These files change _very_ slowly over time, and are quite easy to keep
up to date by the translators.

These patches have been in the -mm tree for a large number of months.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/docs-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/ja_JP/HOWTO                   |  650 +++++++++++++++++++++++++++
 Documentation/ja_JP/stable_api_nonsense.txt |  263 +++++++++++
 Documentation/zh_CN/HOWTO                   |  536 ++++++++++++++++++++++
 Documentation/zh_CN/stable_api_nonsense.txt |  157 +++++++
 4 files changed, 1606 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ja_JP/HOWTO
 create mode 100644 Documentation/ja_JP/stable_api_nonsense.txt
 create mode 100644 Documentation/zh_CN/HOWTO
 create mode 100644 Documentation/zh_CN/stable_api_nonsense.txt

---------------

IKEDA, Munehiro (1):
      Documentation: add Japanese translated stable_api_nonsense.txt

Li Yang (2):
      HOWTO: add Chinese translation of Documentation/HOWTO
      zh_CN/HOWTO: update URLs of git trees

TripleX (1):
      Chinese translation of Documentation/stable_api_nonsense.txt

Tsugikazu Shibata (1):
      HOWTO: add Japanese translation of Documentation/HOWTO

