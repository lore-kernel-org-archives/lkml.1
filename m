Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZG2HcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZG2HcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZG2HcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:32:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63124 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZG2HcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:32:13 -0400
Message-ID: <4A6FFA85.3090409@cn.fujitsu.com>
Date: Wed, 29 Jul 2009 15:30:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] CGroup: Support for named and empty hierarchies
References: <20090728232508.20156.17943.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090728232508.20156.17943.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> The following series implements support for named cgroup hierarchies,
> and for cgroup hierarchies that have no bound subsystems.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Looks nice to me!

