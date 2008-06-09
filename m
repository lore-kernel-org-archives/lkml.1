Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYFIJax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYFIJax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYFIJan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:30:43 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52151 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYFIJam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:30:42 -0400
Message-ID: <484CF82E.1010508@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2008 15:00:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hi, this is third version.
> 
> While small changes in codes, the whole _tone_ of code is changed.
> I'm not in hurry, any comments are welcome.
> 
> based on 2.6.26-rc2-mm1 + memcg patches in -mm queue.
> 

Hi, Kamezawa-San,

Sorry for the delay in responding. Like we discussed last time, I'd prefer a
shares based approach for hierarchial memcg management. I'll review/try these
patches and provide more feedback.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
