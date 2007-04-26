Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbXDZGPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbXDZGPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXDZGPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:15:03 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbXDZGPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:15:00 -0400
Date: Wed, 25 Apr 2007 23:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
Message-Id: <20070425231452.929acac0.akpm@linux-foundation.org>
In-Reply-To: <463041BC.8000708@oracle.com>
References: <20070425224509.46153baa.randy.dunlap@oracle.com>
	<20070425225516.8b573d34.akpm@linux-foundation.org>
	<463041BC.8000708@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 23:07:56 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> oh.  there is already an include/asm-x86_64/const.h that will help
> with that.  I'll try it out.

No there isn't ;)  There's a sparc64 one which looks good.  Worth promoting
to include/linux?
