Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYDCQMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYDCQMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYDCQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:12:12 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:16853 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbYDCQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jm6dYy0kIVkpkEgY+wrXUFrI3Mb9ETBrM5FhLzhaQqmqCbNPFMRhayGhIcKajVNOIaBNFOfwVP4NxFZTUZd73tEX5+bt+0sjLsaT9oGW2AWc2yob0wd5k+TE/Mh82+fQmwNvIEMzLlKh4c9Caz/KPjbIDXgbGoCHTI4/oo44gLg=
Date: Thu, 3 Apr 2008 12:12:04 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.25-rc8
Message-ID: <20080403161204.GA18162@anvil.corenet.prv>
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

to receive updates for the input subsystem. The only change is adding a
few device IDs to appletouch driver to support 4th generation MacBooks.

Changelog:
---------

Tobias Mueller (1):
      Input: appletouch - add product IDs for the 4th generation MacBooks


Diffstat:
--------

 drivers/input/mouse/appletouch.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

-- 
Dmitry
