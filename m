Return-Path: <linux-kernel-owner+w=401wt.eu-S1422953AbXBATQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbXBATQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422952AbXBATQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:16:51 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:56969 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422947AbXBATQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:16:48 -0500
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 14:16:48 EST
Date: Thu, 1 Feb 2007 20:16:47 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Stephen Hemminger <shemminger@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070201191647.GM13130@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Stephen Hemminger <shemminger@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	shemminger@linux-foundation.org, netdev@vger.kernel.org
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de> <20070201110706.74d2c059@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201110706.74d2c059@localhost>
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

> Is this heavy Tx load (ie your watching movie from mac mini). or Rx
> load (you are watching movie on mac mini).

it's inbound (Rx) traffic. Watching a Movie, git pull from linus, or scp
kernel tar tree from my laptop to my mac mini.

        Thomas
