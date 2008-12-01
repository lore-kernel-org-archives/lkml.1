Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYLALhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYLALhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLALh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:37:28 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:26584 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYLALh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:37:28 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: add uid information to sched_debug for
 CONFIG_USER_SCHED
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
In-Reply-To: <20081201112954.GH20329@linux.vnet.ibm.com>
References: <20081201112954.GH20329@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 12:36:56 +0100
Message-Id: <1228131416.7251.306.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 16:59 +0530, Arun R Bharadwaj wrote:
> Hi,
> 
> This patch adds uid information in sched_debug for CONFIG_USER_SCHED

I'd much rather have people working at removing USER_SCHED,. but sure,
the patch looks sane..

