Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXK1B0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXK1B0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXK1B0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:26:25 -0500
Received: from smtp2.Stanford.EDU ([171.67.20.25]:51587 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbXK1B0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:26:24 -0500
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 20:26:24 EST
Subject: 2.6.22.14 + rt?
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 27 Nov 2007 17:02:19 -0800
Message-Id: <1196211739.22601.66.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo... any hope of an updated realtime patch for 2.6.22.14? I'm
having problems with 2.6.23.1 + rt11 (I spent the morning rediffing
agains 2.6.23.9 and just _now_ pressed reload in my browser and there it
is..., rt12 for 2.6.23.9!, argh! :-) and wanted to compare with 2.6.22.x
and the latest I managed to repatch and run successfully is 2.6.22.10. I
did 2.6.22.14 in the afternoon but I obviously bungled it somewhere as
the boot... takes... a... long... time... I can send my .14 patch off
the list if you want/need it. 

[in my 2.6.23.1-rt11 tests I am getting "delayed..." messages from
jackd, smells like a problem with internal timing in the kernel]

I'll try rt12...
-- Fernando


