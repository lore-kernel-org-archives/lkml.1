Return-Path: <linux-kernel-owner+w=401wt.eu-S1763115AbYA3O2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763115AbYA3O2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYA3O1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:27:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:60643 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYA3O1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:27:54 -0500
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <12016890773706-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 4/6] Add multi mport support.
Date: Wed, 30 Jan 2008 08:27:44 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:

> Change lots of static variable to mport private. And add mport to some
> function declaration.

Can you explain this patch further.  Its not clear exactly from this  
commit message why we are doing this.

- k
