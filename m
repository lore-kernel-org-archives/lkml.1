Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXGCQsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXGCQsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760719AbXGCQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:65080 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbXGCQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=QVNULaUZoSCbX49YN2YvPNfotA4a4qZcWOdx2EqY1+QkZnyawrg7rMzyWZo582KlZc8qbqQ4ajipZp9Umn2MkDbdobFE1/oKw2wjVcfnhMHH4Hx7mad/WqGaJNWQW31SsScGL8mOkapO7JwGVQc4RVfO88MtxRDYBMjuA/h2CUY=
Message-ID: <468A7D24.3040004@googlemail.com>
Date: Tue, 03 Jul 2007 18:45:24 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Andre Noll <maan@systemlinux.org>, Christoph Lameter <clameter@sgi.com>
Subject: 2.6.22-rc7: known regressions with patches
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
Andi Kleen                             1
Andrew Morton                          1
Benjamin Herrenschmidt                 1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



Unclassified

Subject         : inconsistent lock state
References      : http://lkml.org/lkml/2007/7/3/195
Last known good : ?
Submitter       : Andre Noll <maan@systemlinux.org>
Caused-By       : ?
Handled-By      : Linus Torvalds <torvalds@linux-foundation.org>
                  Christoph Lameter <clameter@sgi.com>
Patch           : http://lkml.org/lkml/2007/7/3/214
Status          : patch available

Subject    : OProfile issues
References : http://lkml.org/lkml/2007/6/12/207
Submitter  : Stephane Eranian <eranian@hpl.hp.com>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/12/392
             http://lkml.org/lkml/2007/6/20/275
             http://lkml.org/lkml/2007/6/20/276
Status     : patches were suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
