Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYGOFOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYGOFOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYGOFNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:13:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:23262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbYGOFNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,364,1212390000"; 
   d="scan'208";a="418264967"
Subject: Re: [PATCH -mm 2/2] kexec jump -v12: save/restore device state
From: Huang Ying <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080714134805.GD16673@redhat.com>
References: <1215401124.4660.5.camel@caritas-dev.intel.com>
	 <20080714134805.GD16673@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:19:04 +0800
Message-Id: <1216099144.22944.35.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

On Mon, 2008-07-14 at 09:48 -0400, Vivek Goyal wrote:
[...]
> You have cited various possible use cases of this patchset. Which is
> the specific feature you are planning to use?

I think two features are useful:

1. Kexec based hibernation
2. Do kdump then continue

> Thinking more about it, what's the compelling feature out of this list
> which makes this patchset a strong candidate for inclusion?
> 
> Regarding hibernation, Rafael does not think this is the way to go 
> for future.

I think kexec based hibernation can be a better hibernation scheme, at
least more code sharing.

Best Regards,
Huang Ying


