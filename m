Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYJVSho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYJVSho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYJVShg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:37:36 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:38617 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbYJVShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:37:34 -0400
Date: Wed, 22 Oct 2008 14:37:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 01/42] Staging: add pcc-acpi driver
In-reply-to: <1224696563-5170-1-git-send-email-gregkh@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Hiroshi Miura <miura@da-cha.org>,
       YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Message-id: <alpine.LFD.1.10.0810221434070.3010@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081022172203.GA4000@kroah.com>
 <1224696563-5170-1-git-send-email-gregkh@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.
this was already relplaced by the panasonic driver in the acpi tree.

Greg,
If it has the word "acpi" in it, please check with me before
putting something in the staging tree, for I'd prefer to
stage such things in the acpi tree.

thanks,
-Len


On Wed, 22 Oct 2008, Greg Kroah-Hartman wrote:

> From: Hiroshi Miura <miura@da-cha.org>
> 
> Adds the pcc-acpi driver to the staging tree.
> 
> From: Hiroshi Miura <miura@da-cha.org>
> Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/Kconfig             |    2 +
>  drivers/staging/Makefile            |    1 +
>  drivers/staging/pcc-acpi/Kconfig    |   11 +
>  drivers/staging/pcc-acpi/Makefile   |    1 +
>  drivers/staging/pcc-acpi/TODO       |    7 +
>  drivers/staging/pcc-acpi/pcc-acpi.c |  974 +++++++++++++++++++++++++++++++++++
>  6 files changed, 996 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/pcc-acpi/Kconfig
>  create mode 100644 drivers/staging/pcc-acpi/Makefile
>  create mode 100644 drivers/staging/pcc-acpi/TODO
>  create mode 100644 drivers/staging/pcc-acpi/pcc-acpi.c
