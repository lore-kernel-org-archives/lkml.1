Return-Path: <linux-kernel-owner+w=401wt.eu-S935189AbXEIFPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbXEIFPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 01:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXEIFPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 01:15:41 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbXEIFPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 01:15:40 -0400
Message-ID: <464158E9.2000207@zytor.com>
Date: Tue, 08 May 2007 22:15:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86 setup rewrite tree ready for flamage^W review
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I believe the x86 setup tree is now finished.  I will turn it into a
"clean patchset" later this week, but I wanted to get flamed^W feedback
on it first.

The git tree is at:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-newsetup.git
...

... and a flat patch at ...

http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch

	-hpa
