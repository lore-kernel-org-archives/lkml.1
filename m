Return-Path: <linux-kernel-owner+w=401wt.eu-S1763587AbYBFXry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763587AbYBFXry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbYBFXrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:47:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758476AbYBFXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:47:44 -0500
Date: Wed, 06 Feb 2008 15:48:15 -0800 (PST)
Message-Id: <20080206.154815.81536750.davem@davemloft.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080206.153714.133821225.davem@davemloft.net>
References: <20080206.152639.35541094.davem@davemloft.net>
	<20080206233117.GA28931@suse.de>
	<20080206.153714.133821225.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 06 Feb 2008 15:37:14 -0800 (PST)

> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 15:31:17 -0800
> 
> > Do you have CONFIG_SYSFS_DEPRECATED=Y or N?
> 
> I have SYSFS_DEPRECATED=y

I tested with SYSFS_DEPRECATED disabled, it made no
difference.
