Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYBPKKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYBPKKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYBPKKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:10:25 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38578 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbYBPKKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:10:24 -0500
Message-ID: <47B6B5CA.7040201@linux.vnet.ibm.com>
Date: Sat, 16 Feb 2008 15:37:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@in.ibm.com, pj@sgi.com, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
References: <20080215204418.535025000@menage.corp.google.com> <20080215204820.734926000@menage.corp.google.com>
In-Reply-To: <20080215204820.734926000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:

Hi, Paul,

Do we need to use a cgroup.api file? Why not keep up to date documentation and
get users to use that. I fear that, cgroup.api will not be kept up-to-date,
leading to confusion.

Why should the kernel carry so much of documentation in the image as strings?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
