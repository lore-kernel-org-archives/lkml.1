Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYCHLPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYCHLPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYCHLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:15:40 -0500
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:36373 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYCHLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:15:39 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Mar 2008 06:15:39 EST
Date: Sat, 8 Mar 2008 12:06:27 +0100
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: linux-kernel@vger.kernel.org
Subject: suspend not working on macbook pro
Message-ID: <20080308110626.GE4491@ojjektum.uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
suspend. The console is still on, the disk is powered off, but no 
response or poweroff...

Did anyone else met the same thing? How could I help debug it?
What other info would you need?


Thanks,

-- 
pozsy
