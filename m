Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZAHIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZAHIoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZAHIoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:44:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:46854 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751038AbZAHIoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:44:10 -0500
Date: Thu, 8 Jan 2009 19:44:04 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Crutcher Dunnavant <crutcher+kernel@datastacks.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sysrq: add commentary on why we use the console	loglevel over using KERN_EMERG
Message-ID: <20090108084404.GA26403@mail.local.tull.net>
References: <1231364958-26253-1-git-send-email-apw@canonical.com> <1231364958-26253-4-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231364958-26253-4-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 09:49:18PM +0000, Andy Whitcroft wrote:
> Add an explanitory comment as to why we modify the kernel console

         explanatory

> loglevel rather than simply moving sysrq messages to KERN_EMERG level.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Nick.
