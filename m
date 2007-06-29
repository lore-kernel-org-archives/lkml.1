Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbXF2POe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbXF2POe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXF2PNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:13:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48683 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbXF2PNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=lTzaALy9gax3aFEIrpEox/fOtIXgys+Wa71lN2cw7YRomwFZQE4phBuyN+CnRGh3qA7sE/MmFaEThIRm0V7Sm+zCH1dsq54RR7Aut1qmiyDeJ9bvVVB33yxxZ4V4IOkJ9wiIqdyqBuJyPvPkPxvIn1uUtfiX6Wqc7EVdxVeuTt8=
Message-ID: <46852199.1040406@googlemail.com>
Date: Fri, 29 Jun 2007 17:13:29 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: 2.6.22-rc6: known regressions with patches v2
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Hugh Dickins                           2
Andi Kleen                             1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



Unclassified

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
