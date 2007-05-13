Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbXEMQdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbXEMQdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbXEMQdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:33:09 -0400
Received: from smtp.linux-foundation.org ([207.189.120.12]:44674 "EHLO
	smtp.osdl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154AbXEMQdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:33:08 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 12:33:08 EDT
Date: Sun, 13 May 2007 09:23:52 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
Message-ID: <20070513092352.18cd80de@freepuppy>
In-Reply-To: <20070513132517.GA14038@localdomain>
References: <20070513132517.GA14038@localdomain>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 16:25:17 +0300
Dan Aloni <da-x@monatomic.org> wrote:

> Kernel developers might find it useful for quickly getting out from some 
> rough debugging scenarios.
> 
> Signed-off-by: Dan Aloni <da-x@monatomic.org>
> 

There is already the modprobe blacklist ability in user space.
