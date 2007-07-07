Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXGGQHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXGGQHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXGGQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:07:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:41563 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXGGQHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=h5oEy8aZ1MfzbItAxIe4VUmAgRtjQLiSdZigsqusqaATeRITCChF5ahrympeWAC8ih7Ay+9uokaDc6PwVv8RmlovixxmKihdvxLEWBRHT7+gtCJVG+guEe/vRneLCNUuopWB7aC3wHaFNJWS3/DCbaFUKrdexs0WcYyD144va2E=
Message-ID: <468FBA20.8060509@googlemail.com>
Date: Sat, 07 Jul 2007 18:06:56 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>, bluez-devel@lists.sourceforge.net,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: 2.6.22-rc7: known regressions with patches v2
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc7
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Hugh Dickins                           2
Andi Kleen                             2
Andrew Morton                          1
Benjamin Herrenschmidt                 1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Christoph Lameter                      1
David Woodhouse                        1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



Unclassified

Subject         : [2.6.22 regression fix] DLM must depend on SYSFS
References      : http://lkml.org/lkml/2007/7/7/4
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Adrian Bunk <bunk@stusta.de>
Status          : patch available

Subject         : [2.6.22 regression fix] include/linux/kallsyms.h must #include <linux/errno.h>
References      : http://lkml.org/lkml/2007/7/6/359
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Adrian Bunk <bunk@stusta.de>
Status          : patch available



Bluetooth

Subject         : problem with a bluetooth mouse
References      : http://lkml.org/lkml/2007/7/4/321
Last known good : ?
Submitter       : David Woodhouse <dwmw2@infradead.org>
Caused-By       : ?
Handled-By      : Jiri Kosina <jkosina@suse.cz>
                  Dmitry Torokhov <dtor@insightbb.com>
Patch           : http://lkml.org/lkml/2007/7/6/391
Status          : patch available



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
