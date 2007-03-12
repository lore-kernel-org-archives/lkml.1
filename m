Return-Path: <linux-kernel-owner+w=401wt.eu-S965515AbXCLKfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbXCLKfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965519AbXCLKfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:35:47 -0400
Received: from [209.190.27.106] ([209.190.27.106]:34204 "EHLO
	wombat.diezmil.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965515AbXCLKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:35:46 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 06:35:46 EDT
Date: Mon, 12 Mar 2007 06:17:12 -0400
Message-ID: <14418997.1173694632377.JavaMail.root@wombat.diezmil.com>
From: jm.mercy@wanadoo.fr
Reply-To: jm.mercy@wanadoo.fr
To: linux-kernel@vger.kernel.org
Subject: LOCAL_STORAGE: command not found // terminal does not boot!
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I am new to the LTSP local devices, even though my TS works fine. The
need to use local storage (read USB keys) prompted me to install the
local storage part. I am running a 32bit debian etch and followed the
ltsp4.2:
http://wiki.ltsp.org/twiki/bin/view/Ltsp/LTSP-42-LocalDev-DebianEtch
and
http://wiki.ltsp.org/twiki/bin/view/Ltsp/LTSP-42-LocalDev#Troubleshooting
guides. 

However, as soon as I try to boot a terminal, I get the above mentionned
error : "LOCAL_STORAGE: command not found" on the terminal that sits there
and does nothing else. If I remove the line, my terminal boots fine,
obviously without storage. I tried to google and had a look at the list but
found no reference to that problem. What would be the starting point to
find the answer to this question ?
Thank you.

--
This message was sent on behalf of jm.mercy@wanadoo.fr at openSubscriber.com
http://www.opensubscriber.com/messages/linux-kernel@vger.kernel.org/topic.html
