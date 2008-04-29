Return-Path: <linux-kernel-owner+w=401wt.eu-S1758513AbYD2MUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbYD2MUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYD2MU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:20:29 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52492 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbYD2MU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:20:28 -0400
Date: Tue, 29 Apr 2008 17:50:19 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       Balaji Rao <balajirrao@gmail.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, vivk@us.ibm.com
Subject: cgroupstats, plans?
Message-ID: <20080429122019.GE9585@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

You had mentioned in http://lkml.org/lkml/2008/4/8/29 about cgroup
binary API for statistics. What is the status wrt to that?

We are looking to export statistics using libcg. One of the questions
that comes up is when is a file in the cgroup, a control file (one used
to control the parameters of the subsystem) and when is it a file which
is related to statistics. Maybe a binary API might help us there.

Thanks,
-- 
regards,
Dhaval
