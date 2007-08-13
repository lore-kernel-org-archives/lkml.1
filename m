Return-Path: <linux-kernel-owner+w=401wt.eu-S1032006AbXHMSUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032006AbXHMSUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966733AbXHMSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:01:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:27651 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S974370AbXHMSBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=cFSTghBeGktWxpVWm3hJJ9AgEAW/6wrtP+0PsLutpxkA3s6Q2QGRobqXn9bJfGhumimLYwtIriTZPzT6nFBPYG/3LI6DxwDHy2YfLWRHNS0GQ+qg1+Y2Ri4b1XkTHKcL4TTrmHUq6bU6UXxXYroYUVbHHhvbqRsfpjIL/qN2kO0=
Message-ID: <46C09C1A.7050706@googlemail.com>
Date: Mon, 13 Aug 2007 19:59:54 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Dan Merillat <dan.merillat@gmail.com>,
       Paolo Ornati <ornati@fastwebnet.it>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [1/2] 2.6.23-rc3: known regressions with patches
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



Unclassified

Subject         : reset during bootup - 2.6.23-rc2 (git d23cf676)
References      : http://lkml.org/lkml/2007/8/11/177
Last known good : ?
Submitter       : Dan Merillat <dan.merillat@gmail.com>
Caused-By       : Rusty Russell <rusty@rustcorp.com.au>
                  ab144f5ec64c42218a555ec1dbde6b60cf2982d6
Handled-By      : Paolo Ornati <ornati@fastwebnet.it>
                  Andi Kleen <andi@firstfloor.org>
Patch           : http://lkml.org/lkml/2007/8/12/76
Status          : patch was suggested

Subject         : Kconfig prompts without help text
References      : http://lkml.org/lkml/2007/7/16/326
Last known good : ?
Submitter       : Stefan Richter <stefanr@s5r6.in-berlin.de>
Caused-By       : ?
Handled-By      : Jan Engelhardt <jengelh@linux01.gwdg.de>
Patch           : http://lkml.org/lkml/2007/7/18/236
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

Subject         : NFSv4 poops itself
References      : http://lkml.org/lkml/2007/7/27/144
Last known good : ?
Submitter       : Jeff Garzik <jeff@garzik.org> 
Caused-By       : ?
Handled-By      : Trond Myklebust <Trond.Myklebust@netapp.com>
Patch           : http://lkml.org/lkml/2007/7/27/183
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
