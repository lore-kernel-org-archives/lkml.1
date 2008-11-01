Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYKALiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYKALiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 07:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYKALiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 07:38:11 -0400
Received: from ns3.belkam.com ([87.249.237.18]:46331 "EHLO relay2.belkam.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbYKALiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 07:38:11 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Nov 2008 07:38:10 EDT
Message-ID: <490C3D92.5060106@belkam.com>
Date: Sat, 01 Nov 2008 15:29:22 +0400
From: Dmitry Melekhov <dm@belkam.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: serial port problem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have problems with connecting to any equipment since kernel 2.6.24
(Ubuntu 8.04)-
if I connect cisco switch or router I can't do anything with it, but
when I boot previos kernel (from Ubuntu 7.10 )
all is OK.
Today I did upgrade to Ubuntu 8.10 (kernel 2.6.27) and still have the
same problem.
So I downloaded and installed kernel 2.6.27.4 and still have the same
problem.
I connected zyxel modem to port and I see that it gets commsnds- it's
data lamp blinks, but I get nothing.
Situation is different on my colleague machine- since ubuntu 8.04 he can
see in minicom or gtkterm how  connected router boots,
but then he can't send someting over several port to router.
I created bug report in ubuntu's launchpad, but there is no solution.
As I now see this problem exists with kernel from kernel.org could you
tell me how can I find where problem is?

Thank you!


