Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbYJBDcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbYJBDcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 23:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYJBDcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 23:32:12 -0400
Received: from aa.81.b6.static.xlhost.com ([207.182.129.170]:51228 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYJBDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 23:32:12 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2008 23:32:11 EDT
Date: Thu, 2 Oct 2008 06:58:45 -0400
From: auntvini@cel.usyd.edu.au
Reply-To: auntvini@cel.usyd.edu.au
To: linux-kernel@vger.kernel.org
Message-ID: <7971648.51222945125819.JavaMail.root@wombat.diezmil.com>
Subject: Division of Load Average
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My self and my superviosr Dr David Levy have been working on introduction of new kernel code to correct the inherent problem of calculating load avarage by the current kernel. We have posted many e-mails in this regard since 2003 and kernel has been updated under the supervision of Rusty Russel.

Also we had interactions with IBM group(balbir@in.ibm.com)  who was engaged in delayed stat calculations.

We emphasise the following facts
(1) seperation of Disk IO load from CPU load

This comes as a correction to the existing kernel as the calculation of the existing kernel load average is based on the arithmatic addition of Disk IO and CPU loads

(2) In addition to that calculation of load averages for each current user
This is an extention we would like to suggest. For Grid and Cluster computing service providers can use the collection of user load profiles (CPU and Disk IO) for future predictions.

Thanks
Sena Seneviratne
Computer Engineering Lab
Sydney University
Australia

--
This message was sent on behalf of auntvini@cel.usyd.edu.au at openSubscriber.com
http://www.opensubscriber.com/messages/linux-kernel@vger.kernel.org/topic.html
