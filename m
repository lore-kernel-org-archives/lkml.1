Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab0BRNev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:34:51 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:48108 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0BRNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:34:49 -0500
Date: Thu, 18 Feb 2010 14:34:46 +0100
From: lkml@Think-Future.de
To: Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel-Liste <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org
Subject: Re: PROBLEM: oops w/ bridge in 2.6.32.7
Message-ID: <20100218133446.GF2165@localhost>
Reply-To: lkml@Think-Future.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208154735.1d60f43c@nehalam>
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Reported to virtualbox bugtracker.

  The crash so far only happens when starting virtualbox. W/o bridging is working.
  Plain and within a box.

  Thank you.

  Nils

PS: We once had quite unstable kernels using bridge and ebtables modules.
  When loaded those kernel crashed quite fast. This was _some_ versions ago.
  maybe mid-summer 2009? Anyhow, nothing to dig in now except you have a hunch. 
  ;) Just felt to let you know while talking about bridging...

