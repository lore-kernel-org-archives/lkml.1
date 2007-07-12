Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbXGLTvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbXGLTvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbXGLTvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:51:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbXGLTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:51:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/2] Kexec jump: Kexec jump
Date: Thu, 12 Jul 2007 21:58:38 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <1184167836.12556.15.camel@caritas-dev.intel.com>
In-Reply-To: <1184167836.12556.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122158.39024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 July 2007 17:30, Huang, Ying wrote:
> This patch provide the kexec based implementation of hibernation image
> operation. Now, only jumping between original kernel and kexeced
> kernel is supported, real image write/read/check will be provided in
> next patches.

I know a little about kexec.

Could you please tell me what I should know/read to understand this patch?

Greetings,
Rafael 


-- 
"Premature optimization is the root of all evil." - Donald Knuth
