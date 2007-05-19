Return-Path: <linux-kernel-owner+w=401wt.eu-S1764180AbXESWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180AbXESWYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbXESWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:24:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59331 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbXESWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:24:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464F78CA.3040707@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 00:23:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       Marcus Better <marcus@better.se>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [4/5] 2.6.22-rc2: known regressions
References: <464F6DC9.80805@googlemail.com> <464F74DF.6030003@googlemail.com>
In-Reply-To: <464F74DF.6030003@googlemail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Subject    : 2.6.22-rc1 suspend to RAM problem
> References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
> Submitter  : Marcus Better <marcus@better.se>
> Status     : caused by fw-ohci module

akpm forwarded it to linux1394-devel, hence:

Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>,
             Kristian Høgsberg <krh@bitplanet.net>

Alas I am lacking a machine which suspends, but I'm working on it.  If
all fails, I'm gonna have to pull an old APM laptop out of the rubbish.
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
