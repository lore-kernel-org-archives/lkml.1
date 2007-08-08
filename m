Return-Path: <linux-kernel-owner+w=401wt.eu-S935711AbXHHRmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935711AbXHHRmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760781AbXHHRmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:42:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:59501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762076AbXHHRmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:42:45 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: pvp@tk.ru.acad.bg
Subject: Re: 2.6.23-rc1-git10 hangs on boot - needs "acpi=off"
Date: Wed, 8 Aug 2007 13:42:33 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <46B18029.2060509@tk.ru.acad.bg>
In-Reply-To: <46B18029.2060509@tk.ru.acad.bg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081342.34049.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 02:56, Plamen Petrov wrote:

> After reading some mail lists posts, I tried passing "acpi=off" to 
> git10, and it worked - no hang during boot.

please instead try "nolapic" and also "idle=poll"

thanks,
-len
