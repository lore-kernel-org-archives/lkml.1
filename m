Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbXFGPQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbXFGPQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXFGPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:16:35 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4434 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbXFGPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:16:34 -0400
Message-ID: <46682158.6060709@shadowen.org>
Date: Thu, 07 Jun 2007 16:16:40 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: checkpatch.pl: should be executable
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>	 <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>	 <4667F00A.106@shadowen.org> <9a8748490706070452l4e4965b0r2ff6999bac10e237@mail.gmail.com>
In-Reply-To: <9a8748490706070452l4e4965b0r2ff6999bac10e237@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/checkpatch.pl should be executable, make it so.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
old mode 100644
new mode 100755

