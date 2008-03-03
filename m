Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbYCCHXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYCCHXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYCCHXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:23:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYCCHXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:23:13 -0500
Date: Sun, 2 Mar 2008 23:22:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>,
       gregkh <greg@kroah.com>, torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/6] docbook: fix usb source files
Message-Id: <20080302232215.35d0d646.akpm@linux-foundation.org>
In-Reply-To: <20080229220307.7a637ce2.randy.dunlap@oracle.com>
References: <20080229220307.7a637ce2.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 22:03:07 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Fix docbook problems in USB source files.
> These cause the generated docbook to be incorrect.

This gets 100% rejects agaisnt Greg's devel tree (here we go again...)
