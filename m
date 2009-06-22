Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZFVRcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZFVRcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZFVRc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:32:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:65016 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbZFVRcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:32:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="157211577"
Subject: Re: iwl3945 in 2.6.31-rc0: ad-hoc mode broken?
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090619222431.GA2398@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 10:39:40 -0700
Message-Id: <1245692380.24303.494.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Fri, 2009-06-19 at 15:24 -0700, Pavel Machek wrote:
> Hi!
> 
> I tried using ad-hoc mode (against t-mobile G1) on -rc0, and was
> unsuccessful -- never got dhcp. I had to reboot back to
> 2.6.30... Should I try it few more times or is something broken?
> 
> (Also wifi LED stopped working on x60, but that's older issue).
> 

Are you testing Linus's repo here? Should we not maybe wait with testing
until -rc1 is released?

Reinette

