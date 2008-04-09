Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYDIWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYDIWwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYDIWwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:52:42 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:58101 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753301AbYDIWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:52:41 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Thu, 10 Apr 2008 08:52:30 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       samr <sam@ravnborg.org>
Subject: Re: [PATCH v2] documentation: build source files in Documentation	sub-dir
Message-ID: <20080409225229.GC18242@tull.net>
References: <20080403124529.3f2efb79.randy.dunlap@oracle.com> <20080408134613.a047a7b6.akpm@linux-foundation.org> <20080409123551.42c5da0d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409123551.42c5da0d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 12:35:51PM -0700, Randy Dunlap wrote:
> +##oops, this is a kernel module::hostprogs-y := procfs_example

Is this intentional? It looks like you commented-out a mistake.

Nick.
