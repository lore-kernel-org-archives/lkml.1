Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZGPFJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZGPFJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZGPFJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:09:33 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1160 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbZGPFJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:09:33 -0400
Subject: Re: [PATCH] kernel.h: Verify that arguments to swap() are the same
 type
From: Joe Perches <joe@perches.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090716031920.GB5713@cr0.nay.redhat.com>
References: <1247708061.15087.13.camel@Joe-Laptop.home>
	 <20090716031920.GB5713@cr0.nay.redhat.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 22:09:30 -0700
Message-Id: <1247720970.15087.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 11:19 +0800, Amerigo Wang wrote:
> On Wed, Jul 15, 2009 at 06:34:21PM -0700, Joe Perches wrote:
> >Signed-off-by: Joe Perches <joe@perches.com>
> Does this catch any actual wrong usages of swap()?

No.

