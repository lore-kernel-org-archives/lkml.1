Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYADQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYADQQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYADQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:16:08 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:45544 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYADQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:16:07 -0500
Date: Fri, 4 Jan 2008 17:15:30 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: return -EPERM when preventing read of
 /proc/*/maps
Message-ID: <20080104171530.670e74ad@inria.fr>
In-Reply-To: <20080104151931.GC27894@ZenIV.linux.org.uk>
References: <20080104135731.2908.90012.stgit@localhost.localdomain>
	<20080104141443.GB27894@ZenIV.linux.org.uk>
	<20080104153557.13e24970@inria.fr>
	<20080104151931.GC27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> How about this:

At least the task_mmu part works fine.

Tested-by: Guillaume Chazarain <guichaz@yahoo.fr>

-- 
Guillaume
