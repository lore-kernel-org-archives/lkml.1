Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZKXEe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZKXEe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 23:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZKXEe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 23:34:56 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37852 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbZKXEe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 23:34:56 -0500
Date: Tue, 24 Nov 2009 05:35:01 +0100
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: intel, KMS, suspend2ram resume, screen black
Message-ID: <20091124043501.GL30688@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

I am running 2.6.32-rc8 with KMS on Debian/sid:
xserver-xorg: 7.4+4
video-intel: 2.9.0-1

Suspend to RAM and resume works without any problems, but the one that
the screen remains dark. I can switch to a console, can log in there,
can shutdown the computer, all fine, but the sscreen is completely black.

In addition, I have the impression that resume is immediately followed
by a suspend call.

Before swithcing to KMS susepnd/resume worked, so I assume that this
is a KMS issue.

I attach a log (syslog) of the cycle from initial suspend to the
manual shutdown.

Please let me know if I can help debug that in a way.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LUDLOW (n.)
A wad of newspaper, folded tablenapkin or lump of cardboard put under
a wobbly table or chair to make it stand-up straight. It is perhaps
not widely known that air-ace Sir Douglas Bader used to get about on
an enormous pair of ludlows before he had his artificial legs fitted.
			--- Douglas Adams, The Meaning of Liff
