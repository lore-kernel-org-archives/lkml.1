Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYIUW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYIUW4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYIUW41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:56:27 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:37998 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYIUW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FjNxJx4LiPOrq7KhmGUx5EuXWCm7JFcZlA95zFR3PHc1tC+RJrefFEewLRybP3Ll0d
         4/QGByIWIUOobOlVIlNAdyxVGLz58VkY2UbgxzNbWkK1oAuWrtq2jt++cNdSVppkVSPB
         g1/Y76WxXF5ytuzbORoN36pvbdimfFVIpWE/U=
Date: Sun, 21 Sep 2008 18:56:21 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc7
Message-ID: <20080921225621.GA10188@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Henrik Rydberg (1):
      Input: bcm5974 - switch back to normal mode when closing

Kristoffer Ericson (1):
      Input: jornada720_ts - fix build error ( LONG() usage )


Diffstat:
--------

 drivers/input/mouse/bcm5974.c             |   13 +++++++++----
 drivers/input/touchscreen/jornada720_ts.c |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
Dmitry
