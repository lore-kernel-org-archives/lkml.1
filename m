Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYJISjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYJISjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYJISjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:39:11 -0400
Received: from sous-sol.org ([216.99.217.87]:53244 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753407AbYJISjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:39:11 -0400
Date: Thu, 9 Oct 2008 11:37:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Wright <chrisw@sous-sol.org>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technology
	support for Linux - Overview
Message-ID: <20081009183734.GF6912@sequoia.sous-sol.org>
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com> <20081009125311.GD1623@ucw.cz> <20081009174427.GB6912@sequoia.sous-sol.org> <20081009175938.GA12507@elf.ucw.cz> <20081009181451.GD6912@sequoia.sous-sol.org> <20081009182149.GE12507@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009182149.GE12507@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@suse.cz) wrote:
> So like... instead of booting into rootkit it now will not boot at
> all?

Policy dependent, you can control the policy, pick your poison.

> Aha, so instead sleep mode is useless because I'll have to remount all
> the crypto filesystems and restart all the apps...

Heh, no.  I don't think I did a good job describing it.  Maybe Joe can
do better.
