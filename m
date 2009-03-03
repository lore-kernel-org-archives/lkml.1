Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZCCCA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZCCCA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZCCCAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:00:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZCCCAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:00:13 -0500
Message-ID: <49AC8F5D.5010104@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 10:01:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
In-Reply-To: <20090303013432.11211.18662.stgit@menage.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int generate_sched_domains(struct cpumask **domains,
> +			struct sched_domain_attr **attributes)
> +{

return 0;

> +}
