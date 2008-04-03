Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYDCQWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYDCQWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYDCQW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:22:28 -0400
Received: from sigma957.CIS.mcmaster.ca ([130.113.64.83]:43268 "EHLO
	sigma957.cis.mcmaster.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYDCQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:22:27 -0400
X-Greylist: delayed 3949 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 12:22:27 EDT
From: "Gabriel A. Devenyi" <ace@staticwave.ca>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [REGRESSION] BCM4306 cannot associate with any version of b43 driver
Date: Thu, 3 Apr 2008 11:15:52 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031115.52596.ace@staticwave.ca>
X-PMX-Version-Mac: 5.4.1.325704, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.4.3.75735
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='BODY_SIZE_600_699 0, ECARD_WORD 0, __C230066_P3_4 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I feel I have to escalate this regression to the mailing lists because I've had 
no response on the kernel bugzilla from quite some time now.

With the release of the b43 driver, my card can no longer associate with its AP. 
I've been testing with 2.6.24 and the wireless-git tree hoping that someone 
would fix it, but I've had no requests for testing and no response.

http://bugzilla.kernel.org/show_bug.cgi?id=9987

What else do I need to do to get someone to help me? More debugging information? 
Please ask me to do something, I'm trying to be an active participant in the 
process...

-- 
Gabriel A. Devenyi B.Eng.
ace@staticwave.ca
