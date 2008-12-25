Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbYLYPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbYLYPcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYLYPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:32:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52379 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYLYPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:32:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4953A759.2070609@s5r6.in-berlin.de>
Date: Thu, 25 Dec 2008 16:31:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/7] drivers/media/dvb/firesat: Use DEFINE_SPINLOCK
References: <Pine.LNX.4.64.0812251534060.22039@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812251534060.22039@ask.diku.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
> in Documentation/spinlocks.txt

Committed to linux1394-2.6.git.  Thanks,
-- 
Stefan Richter
-=====-==--- ==-- ==--=
http://arcgraph.de/sr/
