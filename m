Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYBDLhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYBDLhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYBDLhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:37:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:2249 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYBDLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=jZkCrP9Fz9X0w3GpjxrdH2PiQu8qXnWfJbMhZCGIl/bq11izLaA7gnD8v3NHWAcKdJL+NYmQy1mskgdAS21ar2m7/t+wOb69WJc9mJGP4oqom7k5SgP9xzExcDmKi6rxT3zBweon7IzP7j7EchuF0oKz+qsYWRAZjD1bMVuKm0A=
Date: Mon, 4 Feb 2008 12:37:14 +0100
To: ben@simtech.co.uk, Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Questions regarding mfd drivers
Message-Id: <20080204123714.4be6e10c.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Trying to wrap my head around sm501. From what I can tell an mfd driver is a "master" driver that takes control of all
memory and io areas. It then hands out areas of those to drivers. Anywhere near correct?

I can see some benefit but still hard for me to motivate. What am I missing? What will the mfd be able to do, that I lack now?

The sm501 driver seems way more advanced than I will need for hd64461/hd64465 anyhow, but still need to understand sm501 completely before
attempting to write one on my own. Anyone know any documentation aside from example drivers?

Best wishes
Kristoffer
