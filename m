Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYAZKlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYAZKlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYAZKkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:40:53 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:56277 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbYAZKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=T/TdwG+KWAxRLAK2quHnFSlp9dhBbP0qvpPVjWUQS6Xnc0QusjUxlsE6Dx2rT6J7yd39Z+iPmTGNWJmE37IQTo6wOvBiDAtr9kM+g6McBQn6ubCuQDQemB5eXk8Dhaq0zeHLVTmIHV+nvC+oawyYq52nmEMzqlW1HHvJC7rswww=
Date: Sat, 26 Jan 2008 18:38:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: The latest linus tree can't build
Message-ID: <20080126103845.GF20935@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Sam!

When I built the latest linus tree, I got this error:

...
  CC      sound/oss/msnd.o
make[2]: *** No rule to make target `/etc/sound/msndperm.bin', needed by `sound/oss/msndperm.c'.  Stop.
make[1]: *** [sound/oss] Error 2
make: *** [sound] Error 2

My .config is just the one I sent to you in another thread.
Need me to resend it?

Regards.


