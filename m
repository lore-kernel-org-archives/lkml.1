Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXCMPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXCMPvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXCMPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:51:43 -0400
Received: from www17.your-server.de ([213.133.104.17]:4733 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXCMPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:51:42 -0400
Message-ID: <1173801099.45f6c88bef4c4@213.133.104.17>
Date: Tue, 13 Mar 2007 16:51:39 +0100
From: thomas@m3y3r.de
To: tomi@nomi.cz
Cc: linux-kernel@vger.kernel.org
Subject: Re: [5/6] 2.6.21-rc3: known regressions
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 129.35.231.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject : suspend/resume hangs until keypress
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8181
> Submitter : Tomas Janousek <tomi@xxxxxxx>
> Status : unknown

Can you please try to compile without nohz and without hrtimers and try it
again?

This is maybe the same error i encounter. See also:
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.1/1506.html

with kind regards
thomas
