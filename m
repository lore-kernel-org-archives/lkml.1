Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbYBNOWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbYBNOWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYBNOV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:21:58 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:40941 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYBNOV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:21:57 -0500
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: user-mode-linux-user@lists.sourceforge.net
Subject: Re: 2.6.24.2 won't compile UML
Date: Thu, 14 Feb 2008 15:21:41 +0100
User-Agent: KMail/1.9.7
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org,
       Gabriel C <crazy@frugalware.org>
References: <200802141213.09859.philipp.marek@bmlv.gv.at> <200802141433.29839.philipp.marek@bmlv.gv.at>
In-Reply-To: <200802141433.29839.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141521.41756.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the noise ... 
Going to another machine with a recent gcc, and re-applying the config file 
seems to work, I now got a image.

Just have to get it working now ...


Gabriel: I just got it working.
That was a plain 2.6.24.2 untar - but the "make ARCH=um bzImage" seems to make 
a mess.

Thank you nonetheless.


Regards,

Phil
