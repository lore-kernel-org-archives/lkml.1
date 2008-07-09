Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYGIQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYGIQFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYGIQFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:05:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYGIQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:05:38 -0400
Date: Wed, 9 Jul 2008 11:58:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: scripts/gcc-x86_64-has-stack-protector.sh missing ?
Message-ID: <20080709155844.GB29961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just did a 'make tags' on a fresh checkout of Linus' tree, and got this..

/bin/sh: /mnt/data/src/git-trees/kernel/linux-2.6/scripts/gcc-x86_64-has-stack-protector.sh: No such file or directory

arch/x86/Makefile references this, but it seems to not be in the tree.

	Dave

-- 
http://www.codemonkey.org.uk
