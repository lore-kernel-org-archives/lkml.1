Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZCWTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZCWTBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZCWTBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:01:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZCWTBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:01:37 -0400
Message-ID: <49C7DC8B.4020904@suse.de>
Date: Mon, 23 Mar 2009 20:01:31 +0100
From: Stefan Seyfried <seife@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.19) Gecko/20081227 SUSE/2.0.0.19-1.31 Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: [Bug #12818] iwlagn broken after suspend to RAM (iwlagn: MAC
 is in deep sleep!)
References: <HPkmj74uawF.A.iqE.M8TxJB@chimera> <fnEpM0mQZjO.A.L_E.W8TxJB@chimera>
In-Reply-To: <fnEpM0mQZjO.A.L_E.W8TxJB@chimera>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).

It still does not work with 2.6.29-rc8.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12818
> Subject		: iwlagn broken after suspend to RAM (iwlagn: MAC is in deep sleep!)
> Submitter	: Stefan Seyfried <seife@suse.de>
> Date		: 2009-03-04 08:32 (18 days old)
-- 
Stefan Seyfried
R&D Team Mobile Devices            |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg | "Well, surrounding them's out."

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
