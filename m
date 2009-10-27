Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZJ0B3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZJ0B3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZJ0B3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:29:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36409 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbZJ0B3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:29:49 -0400
Subject: What ever happened to: [PATCH] MIPS: add support for
 gzip/bzip2/lzma compressed kernel images
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: ralf@linux-mips.org, alex@digriz.org.uk, ithamar.adema@team-embedded.nl,
       linux-mips <linux-mips@linux-mips.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 21:29:26 -0400
Message-Id: <1256606966.26028.364.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm playing with ftrace on MIPS thanks to Lemote for supplying me a
machine. And I noticed that, although Wu's repo gives me a nice vmlinuz
to install, the default kernels do not.

Wu wrote a nice patch that adds this feature, and I see that he posted
it a few months back:

http://www.linux-mips.org/archives/linux-mips/2009-08/msg00056.html

I do not see it in the mainline nor in Ralf's repo on kernel.org. I'm
hoping that it did not get lost and forgotten. What ever happened to it?

Thanks,

-- Steve


