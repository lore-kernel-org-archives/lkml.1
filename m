Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYKDWdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYKDWdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYKDWcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:32:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:7520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYKDWcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:32:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,545,1220252400"; 
   d="scan'208";a="70976571"
Subject: Re: [Bug #11806] iwl3945 fails with microcode error
From: reinette chatre <reinette.chatre@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <wOAXuecskPD.A.ezH.OleDJB@chimera>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
	 <wOAXuecskPD.A.ezH.OleDJB@chimera>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 14:33:21 -0800
Message-Id: <1225838001.1115.575.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-02 at 08:06 -0800, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11806
> Subject		: iwl3945 fails with microcode error
> Submitter	: Johannes Berg <johannes@sipsolutions.net>
> Date		: 2008-10-22 02:36 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=122450235730661&w=4
> Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
> 

A patch for this issue has just been sent to John Linville. 
Reference: http://marc.info/?l=linux-wireless&m=122583010822172&w=2

Reinette


