Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXICKMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXICKMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbXICKLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:11:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:33754 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbXICKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=FZiQPogQySJ5umasPgE12YZyGjY8/CSfJWbaNKw8EkUpF5h/5GEJ3osW0S3tUlyKQQVmeAoVIdzkMPt1m1ASvBZB+KkKqAkTSwcUbAYuAV6XLe+7i0T4MYu67cbOmKbuQRC+owqa+Y2zbhhliOVBqPnLl92JNTbBN99sqJhWA9g=
Message-ID: <46DBDDB7.2090806@googlemail.com>
Date: Mon, 03 Sep 2007 12:11:03 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Harry Edmon <harry@atmos.washington.edu>, Hua Zhong <hzhong@gmail.com>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Bret Towe <magnade@gmail.com>, Tony Breeds <tony@bakeyournoodle.com>
Subject: [1/2] 2.6.23-rc5: known regressions with patches
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Unclassified

Subject         : 8250 claims non existing device blocking IO port
References      : http://lkml.org/lkml/2007/8/18/20
Last known good : ?
Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
Caused-By       : ?
Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch           : http://lkml.org/lkml/2007/8/21/291
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



FS

Subject         : NFSv4 client OOPS
References      : http://lkml.org/lkml/2007/8/28/207
Last known good : ?
Submitter       : Harry Edmon <harry@atmos.washington.edu>
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/8/28/204
Status          : patch available

Subject         : autofs mounts mysteriously disappeared
References      : http://lkml.org/lkml/2007/8/29/222
                  http://lkml.org/lkml/2007/8/30/234
Last known good : 2.6.22
Submitter       : Hua Zhong <hzhong@gmail.com>
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/8/31/189
Status          : patch available



IDE

Subject         : linux-2.6.23-rc4 ppc build failure
References      : http://lkml.org/lkml/2007/8/29/154
Last known good : ?
Submitter       : Bret Towe <magnade@gmail.com>
Caused-By       : ?
Handled-By      : Tony Breeds <tony@bakeyournoodle.com>
Patch           : http://lkml.org/lkml/2007/8/31/1
Status          : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
