Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYJ3O13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYJ3O13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYJ3O1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:27:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbYJ3O1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:27:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Andreas Hartmetz" <ahartmetz@gmail.com>
Subject: Re: RAID ate my PCIe-PCI bridge's MMIO address space (?)
Date: Thu, 30 Oct 2008 15:31:46 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <f3642e6b0810300413u47398c0do76098b8fa1242d74@mail.gmail.com>
In-Reply-To: <f3642e6b0810300413u47398c0do76098b8fa1242d74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810301531.46409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 30 of October 2008, Andreas Hartmetz wrote:
> Please ignore my amateurish guessing about the cause of the ALSA breakage
> from the previous mail - booting from live CD without the "quiet" option
> leads to the same shpchp error message in syslog, but the soundcard still
> works. Maybe I should just reinstall and see what happens :/
> Anyway, here's the /var/log/syslog produced by booting the live CD *without*
> quiet:

Could you please report the problem once again with a better subject and more
precise description (tell us which kernels work and which don't, for example).

Thanks,
Rafael
