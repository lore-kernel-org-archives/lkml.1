Return-Path: <linux-kernel-owner+w=401wt.eu-S932314Ab0ANXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0ANXN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903Ab0ANXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:13:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598Ab0ANXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:13:27 -0500
Date: Thu, 14 Jan 2010 15:12:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add --sections, print entire
 matched subsystem
Message-Id: <20100114151254.72b57501.akpm@linux-foundation.org>
In-Reply-To: <1263408063.8011.116.camel@Joe-Laptop.home>
References: <1263408063.8011.116.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 10:41:03 -0800
Joe Perches <joe@perches.com> wrote:

> Print the complete contents of the matched subsystem in pattern
> match depth order.
> 

It would be much easier for us to understand the proposed change if the
changelog contained some example output, please.

