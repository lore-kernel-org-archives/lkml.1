Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbXAZWvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbXAZWvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXAZWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:51:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXAZWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:51:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45BA85A1.1030707@s5r6.in-berlin.de>
Date: Fri, 26 Jan 2007 23:50:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux1394-Devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6-rt2: kernel oops when ejecting cardbus firewire card
References: <45BA743B.2080401@joow.be>
In-Reply-To: <45BA743B.2080401@joow.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
> cc'ing linux1394-devel because it seems to be a problem in the ieee1394 
> stack.

Yes, this bug is in stock Linux 2.6 too. Ever has been.
http://bugzilla.kernel.org/show_bug.cgi?id=7121
-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/
