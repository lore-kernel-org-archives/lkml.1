Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYFCLha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYFCLha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYFCLhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:37:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40017 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYFCLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:37:22 -0400
Date: Tue, 3 Jun 2008 13:37:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Who can backport the AHCI driver to older kernels
In-Reply-To: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
Message-ID: <alpine.LNX.1.10.0806031332410.4055@fbirervta.pbzchgretzou.qr>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-03 12:47, Rainer Koenig wrote:
>
>New mainboard platfrom with latest chipset from a chipset vendor that 
>can't do the job that we are asking for. The chipset (especially the
>SATA controller is supported in Kernel 2.6.24 and later. 
>
>The target market for those boards is using old fashioned distributions 
>like CentOS, Debian, Fedora 8 openSUSE 10 and so on.

Wait a minute, that seems like an impossible dependency.
These boards cannot be targeted for these distro versions,
because the manufacturer knows (hopefully) that the shipped
kernel versions do not have the driver with the required
new code.
