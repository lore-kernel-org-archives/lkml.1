Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbXI0Ga0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbXI0Ga0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 02:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXI0GaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 02:30:15 -0400
Received: from tartu.cyber.ee ([193.40.6.68]:2161 "EHLO tartu.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXI0GaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 02:30:14 -0400
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 02:30:13 EDT
From: Meelis Roos <mroos@linux.ee>
To: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8: Known regressions from 2.6.22
In-Reply-To: <200709270127.40471.rjw@sisk.pl>
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.23-rc7-g335fb8fc (i686))
Message-Id: <20070927061902.84E0013CFD@rhn.tartu-labor>
Date: Thu, 27 Sep 2007 09:19:02 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

RJW> This message lists some known regressions from 2.6.22 for which there are
RJW> no fixes in the mainline that I know of.  If any of them have been fixed
RJW> already, please let me know.
RJW> 
RJW> If you know of any other unresolved regressions from 2.6.22, please let me know
RJW> either and I'll add them to the list.

psmouse compile problem on alpha is still present and I have not had
time to find out what these param_protos are:
http://lkml.org/lkml/2007/9/22/64

-- 
Meelis Roos
