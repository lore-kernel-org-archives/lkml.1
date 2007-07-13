Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbXGMJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbXGMJjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbXGMJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:39:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47513 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXGMJjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:39:05 -0400
Date: Fri, 13 Jul 2007 13:38:51 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] w1_ds2760: Fix binary file read callback signature
Message-ID: <20070713093851.GA11658@2ka.mipt.ru>
References: <20070713112643.6a6daf73@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070713112643.6a6daf73@hyperion.delvare>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 11:26:43AM +0200, Jean Delvare (khali@linux-fr.org) wrote:
> Commit 91a6902958f052358899f58683d44e36228d85c2 changed the binary
> sysfs file signatures at the same time the w1_ds2760 driver was added.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>

I have no problem with this patch. Should I forward it to Andrew or you
will pick this up?

Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

-- 
	Evgeniy Polyakov
