Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYGBWCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYGBWCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGBWCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:02:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbYGBWCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:02:11 -0400
Date: Wed, 2 Jul 2008 14:58:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vda.linux@googlemail.com, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk,
       dhowells@redhat.com, ralf@linux-mips.org, kernel@wantstofly.org,
       jwboyer@linux.vnet.ibm.com, paulus@samba.org, dwmw2@infradead.org,
       andi@firstfloor.org, torvalds@linux-foundation.org,
       paul.gortmaker@windriver.com, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       schwidefsky@de.ibm.com, davem@davemloft.net
Subject: Re: [PATCH 21/23] make section names compatible with
 -ffunction-sections -fdata-sections: v850
Message-Id: <20080702145859.a9af30ea.akpm@linux-foundation.org>
In-Reply-To: <200807022345.40184.arnd@arndb.de>
References: <200807020242.21960.vda.linux@googlemail.com>
	<200807022345.40184.arnd@arndb.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 23:45:38 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 02 July 2008, Denys Vlasenko wrote:
> > This patch fixes v850 architecture.
> 
> For all I know, v850 has been broken and unmaintained for a few years now,
> didn't someone have a patch to remove it entirely?
> 

yup, it's queued for 2.6.27-rc1.
