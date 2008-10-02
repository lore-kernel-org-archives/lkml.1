Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYJBBow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYJBBow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJBBoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:44:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYJBBon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:44:43 -0400
Message-ID: <48E4270A.5030107@kernel.org>
Date: Thu, 02 Oct 2008 10:42:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Scott Pitcher <scottpitcher@netspace.net.au>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Joseph Chan <JosephChan@via.com.tw>
Subject: Re: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
References: <loom.20080902T014408-4@post.gmane.org> <20080903095359.27961778.akpm@linux-foundation.org>
In-Reply-To: <20080903095359.27961778.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Oct 2008 01:44:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can you please test the attached patch?  It's on top of the upstream
branch of Jeff's libata-dev tree.

  http://www.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
  git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

If you're unfamiliar with git, just lemme know.  I'll send you a patch
against 2.6.27-rc8.

Thanks.

-- 
tejun
