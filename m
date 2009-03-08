Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZCHCwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZCHCwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 21:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZCHCwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 21:52:04 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:51927 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZCHCwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 21:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QafUnL2hLm0DzS9FI2lISVUdm5QQER9QflFAvwB1EbcWfN30m6IP74IrefTs/20nbx
         yil+jfccEZXVTLmbG1HBTPjGm6Q6GJHyEv+o4jKu+zcxbLPBM2GMMLvN0xWJmpXQA0cF
         +xtQUHCUuyTmNwgys8zu0L0KArI9pyIihu+R8=
Date: Sat, 7 Mar 2009 18:51:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.29-rc7
Message-ID: <20090308025055.GB22645@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Dmitry Torokhov (1):
      Input: serio - fix protocol number for TouchIT213


Diffstat:
--------

 include/linux/serio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Dmitry

