Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbYCXT0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbYCXT0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbYCXT01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:26:27 -0400
Received: from brmea-mail-3.Sun.COM ([192.18.98.34]:48730 "EHLO
	brmea-mail-3.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467AbYCXT00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:26:26 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2008 15:26:26 EDT
Date: Mon, 24 Mar 2008 15:16:00 -0400
From: David Collier-Brown <davecb@Sun.COM>
Subject: Vicious reviewer needed,  for a bug reporting article
To: linux-kernel@vger.kernel.org
Cc: Alan Rocker <arocker@vex.net>
Reply-to: davecb@Sun.COM
Message-id: <47E7FDF0.8090607@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar once said (http://lwn.net/Articles/251784):
|  We must not ignore people who tell us that "there is something wrong
| going on here", just because they are unable to analyze it themselves.
| Very often where we end up saying "we don't know what's going on here"
| it's likely _our_ fault. We also must not hide behind "please do these
| 10 easy steps and 2 kernel recompiles and 10 reboots, only takes half
| a day, and come back to us once you have the detailed debug data"
| requests.

  To help address this, Alan Rocker and I wrote an article about how
to do a good report of a kernel crash or hang, based on a course
we gave for a well-known board supplier, on diagnosing and reporting
bugs in their Linux drivers.

  We're nervous about the last few steps, submitting bugs to the 
kernel community, so we'd like people who care about the quality 
of bug reports to review us. Viciously. With lots of thrown
brickbats. We'd really prefer to have it right before publishing (;-)) 

  Everyone interested, drop me a line.

--dave (currently contracting at Sun in Toronto) c-b
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
