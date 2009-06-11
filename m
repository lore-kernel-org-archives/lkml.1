Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZFKRl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZFKRl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZFKRlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:41:51 -0400
Received: from eng.riverbed.com ([208.70.196.44]:62736 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZFKRlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:41:51 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 13:41:51 EDT
Date: Thu, 11 Jun 2009 10:33:12 -0700
From: Chaitanya Lala <clala@riverbed.com>
To: minyard@acm.org
Cc: martin.wilck@ts.fujitsu.com, linux-kernel@vger.kernel.org,
       clala@riverbed.com
Subject: Regarding patchwork patch #28003
Message-ID: <20090611173312.GA7450@clala-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have been facing the issue of the kipmid's CPU usage spiking since a long time.
I have tested the patch sent by Martin (limit CPU time spent in kipmid (version 4)) and it solves the issue for me.
I do not see any activity/feedback on the patch.
Can I help in some-way to ensure that this patch is merged ?

Thanks & Regards,
Chaitanya
