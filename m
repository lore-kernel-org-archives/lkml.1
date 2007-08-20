Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbXHTQMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbXHTQMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbXHTQMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:12:16 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:57388 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721AbXHTQMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:12:13 -0400
Date: Mon, 20 Aug 2007 09:11:28 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, rientjes@google.com, akpm@linux-foundation.org,
       ak@suse.de
Subject: perfmon2 kernel: git tree up and running
Message-ID: <20070820161128.GB10272@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070820131605.GE8667@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820131605.GE8667@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am happy to announce that we now have a GIT tree for the perfmon2
kernel. This way you will all be able to track closely the latest
perfmon2 changes. We will also be able to better track the main
kernel changes.

You can get your copy of the tree by doing:

        git clone git://git.kernel.org/pub/scm/linux/kernel/git/eranian/linux-2.6

As of today, you have 2.6.23-rc3 + the latest perfmon changes from 2.6.22.

The tree also includes modifications to the Intel Core processors support
to allow more than one counter to be used when PEBS is active.

Enjoy,

--
-Stephane
