Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbYBAHr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbYBAHr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYBAHjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934870AbYBAHjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:51 -0500
Date: Thu, 31 Jan 2008 23:40:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yi.y.yang@intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] Add new string functions strict_strto* and
 convert kernel params to use them, take 2
Message-Id: <20080131234005.ab6962f3.akpm@linux-foundation.org>
In-Reply-To: <1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	<1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	<1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	<1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	<1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
	<1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 06:11:43 +0800 Yi Yang <yi.y.yang@intel.com> wrote:

> --- a/include/linux/kernel.h	2008-01-31 00:41:46.000000000 +0800
> --- b/include/linux/kernel.h	2008-02-01 04:30:49.000000000 +0800

This isn't a patch.  I wonder how that happened?
