Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbXCDRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbXCDRdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXCDRdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:33:39 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:38277 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbXCDRdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:33:39 -0500
Date: Sun, 4 Mar 2007 18:33:22 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <742277.25048.qm@web52514.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0703041832180.23714@yvahk01.tjqt.qr>
References: <742277.25048.qm@web52514.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4 2007 08:25, Marc Perkel wrote:
>I'm running the latest OpenVZ kernel 2.6.18. I'm not
>sure if this is a factor or not as the problem occurs
>without starting any VEs.
>
>I've never used raid 10 before (stripes on top of 2
>mirrors) so I don't have anything to compare this
>with. I'm just wondering if I'm doing something wrong.

Are you using raid1+0 (3 md devices) or raid10 (1 raid device)?
Depending on which, you might want to try the other.


Jan
-- 
