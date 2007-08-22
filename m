Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXHVVDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXHVVDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932434AbXHVVCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:02:54 -0400
Received: from main.gmane.org ([80.91.229.2]:47156 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbXHVVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:02:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: TV card detected wrongly by the kernel. Any chance to get this fixed?
Date: Wed, 22 Aug 2007 23:08:00 +0200
Message-ID: <fai89b$ms1$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c3cb.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a BT878 based TV card (was sold by a german discounter some years 
ago).

Unfortunately this card gets detected wrongly and so I'm unable to watch 
tv, if I allow the kernel to auto-detect the card.

If I unload the module and reload it using the right "card=" value, then 
anything works well. So one of the first steps, I do if I install a new 
version of my distribution, is to place the "unload module and reload 
with the right value" code to my "rc.local" file.

Is there any chance to get this card added to the kernel, so the right 
value gets auto-loaded?

Thanks in advance

Yours

Manuel Reimer

