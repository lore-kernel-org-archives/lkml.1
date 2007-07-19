Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXGSJFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXGSJFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXGSJFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:05:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58605 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbXGSJFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:05:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Date: Thu, 19 Jul 2007 11:13:21 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070718180420.02352d4f.akpm@linux-foundation.org> <1184827403.15756.14.camel@caritas-dev.intel.com>
In-Reply-To: <1184827403.15756.14.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191113.22711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 19 July 2007 08:43, Huang, Ying wrote:
> On Wed, 2007-07-18 at 18:04 -0700, Andrew Morton wrote:
> > I like the idea but I think I'll let people chat about it a bit more
> > before looking at merging the patches, OK?
> 
> I think maybe we should wait for Rafael to separate the device hibernate
> (quiesce and state save) from device suspend.

Well, I'm afraid that will take some time ...

> Without that, the ACPI issue can not be resolved.

Yes, it seems so.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
