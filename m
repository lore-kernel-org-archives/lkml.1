Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYFCLwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYFCLwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYFCLwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:52:36 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:2838 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbYFCLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:52:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Subject: Re: Who can backport the AHCI driver to older kernels
Date: Tue, 3 Jun 2008 13:52:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
In-reply-To: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031352.31940.elendil@planet.nl>
X-OriginalArrivalTime: 03 Jun 2008 11:52:33.0277 (UTC) FILETIME=[4F049AD0:01C8C570]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rainer Koenig wrote:
> New mainboard platfrom with latest chipset from a chipset vendor that
> can't do the job that we are asking for. The chipset (especially the
> SATA controller is supported in Kernel 2.6.24 and later.
> 
> The target market for those boards is using old fashioned distributions
> like CentOS, Debian, Fedora 8 openSUSE 10 and so on. So the gap is that
> the latest driver from 2.6.24 is not yet in those distributions.

Debian will offer the option to install a system using 2.6.24 with its 
next update for Etch (stable). That point release is expected within the 
next few weeks.

Cheers,
FJP
