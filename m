Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbXKUJXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbXKUJXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXKUJXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:23:21 -0500
Received: from web33012.mail.mud.yahoo.com ([209.191.69.127]:30086 "HELO
	web33012.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751970AbXKUJXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:23:20 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 04:23:19 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=pZ9qxdxywuhIdyQuvl5wrVa1HdgmfukezmDqLdH1C46BNvTdiTJ65ie6i17aVvLDR7qntbF+kwqVfd2Rs1q/Vh67y4HaVSHdmQ67Q3SYW30AFKSaFkFkXXTDbVgBSKmAA3OhwCBLN13qsIra9pzEKrQWForvXEhW1IpebxW74w8=;
X-Mailer: YahooMailRC/818.27 YahooMailWebService/0.7.157
Date: Wed, 21 Nov 2007 01:16:37 -0800 (PST)
From: Max <maxw_gcc@yahoo.com>
Subject: Kernel .config  and kconfig general question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <505418.54128.qm@web33012.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it the same to comment out a variable in .config than assigning 'N' to it?

Also could somebody explain the big picture of how does the kernel
configuration/build process treats the commented out variables in
.config?

Or even more general:

Could anybody please help me in understanding the main picture of how a .config variable gets #define'd or #undefine'd in the kernel
header files?




Many thanks,

Max



      ____________________________________________________________________________________
Be a better pen pal. 
Text or chat with friends inside Yahoo! Mail. See how.  http://overview.mail.yahoo.com/
