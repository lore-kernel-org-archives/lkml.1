Return-Path: <linux-kernel-owner+w=401wt.eu-S1161213AbXDEFl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161213AbXDEFl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161216AbXDEFl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:41:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46615 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161213AbXDEFl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:41:57 -0400
Date: Wed, 4 Apr 2007 22:41:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
Message-Id: <20070404224152.29062e47.akpm@linux-foundation.org>
In-Reply-To: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 22:05:34 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Use documented tag for "IA-32" (not "i386") to indicate which
> kernel parameters apply to IA-32.

mv arch/i386 arch/ia32 ;)

Seriously, is there any point in this?  Kernel uses the i386 terminology
and surely there's no confusion over what that represents.
