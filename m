Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbXHJHUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbXHJHUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXHJHU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:20:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42833 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbXHJHU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:20:26 -0400
Date: Fri, 10 Aug 2007 11:20:09 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: + sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch added to -mm tree
Message-ID: <20070810072008.GA6639@localhost.sw.ru>
References: <200708092211.l79MBkBv022129@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708092211.l79MBkBv022129@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:11:46PM -0700, akpm@linux-foundation.org wrote:
> In sysctl.h the typedef struct ctl_table ctl_table violates coding style isn't
> needed and is a bit of a nuisance because it makes it harder to recognize
> ctl_table is a type name.

Looks good.

