Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXJCAFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXJCAFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXJCAFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:05:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:48286 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXJCAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ikRxDAS+iV1+Xb2FuMlvwxM6HQec16Ucl+dFs5gYQM0MPbLSRmIxExbeX/JSQEL1i7eE9voVTMIdDlVTDQ1/Hr+FOm+7rbTtlBZBFOP1LV47QoPq64Knr7HlwuN26mXmWbySadtQmjj+4nFhRYJPbtJqMcEtnb8DzTR1aELRZik=
Message-ID: <9dbec86d0710021705j3a20e411hb3e9b34e622f9a85@mail.gmail.com>
Date: Wed, 3 Oct 2007 08:05:30 +0800
From: Sonny <smaniaol@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.4 vs 2.6 Traffic Controller performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
I hope this is the right place to ask this.Does any know if there is a
substantial difference in the performance of the traffic controller
between kernel 2.4 and 2.6. We tested it using 1 iperf server and use
250 and 500 clients, altering the burst. We use the top command to
check the idle time of our router to see this. The results we got from
the 2.4 kernel shows around 65-70% idle time while the 2.6 shows
60-65% idle time. We tried to use MRTG and we're not getting any
results either. We want to know if we could improve the bandwidth by
upgrading the kernel, else we would have to get a new bandwidth
manager.  Could anyone have the similar test regarding this. Thanks in
advance.
