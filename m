Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYFCMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYFCMHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYFCMHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:07:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53901 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbYFCMHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:07:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18501.13296.224958.291840@harpo.it.uu.se>
Date: Tue, 3 Jun 2008 14:07:12 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Frans Pop <elendil@planet.nl>
Cc: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Who can backport the AHCI driver to older kernels
In-Reply-To: <200806031352.31940.elendil@planet.nl>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
	<200806031352.31940.elendil@planet.nl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop writes:
 > Rainer Koenig wrote:
 > > New mainboard platfrom with latest chipset from a chipset vendor that
 > > can't do the job that we are asking for. The chipset (especially the
 > > SATA controller is supported in Kernel 2.6.24 and later.
 > > 
 > > The target market for those boards is using old fashioned distributions
 > > like CentOS, Debian, Fedora 8 openSUSE 10 and so on. So the gap is that
 > > the latest driver from 2.6.24 is not yet in those distributions.
 > 
 > Debian will offer the option to install a system using 2.6.24 with its 
 > next update for Etch (stable). That point release is expected within the 
 > next few weeks.

Redhat seems to regularly backport the entire libata layer
to at least 2.6.18 (RHEL5) and maybe also 2.6.9 (RHEL4).
