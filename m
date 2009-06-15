Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZFOKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZFOKnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZFOKnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:43:25 -0400
Received: from ozlabs.org ([203.10.76.45]:51543 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZFOKnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:43:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpumask: use zalloc_cpumask_var() where possible
Date: Mon, 15 Jun 2009 20:13:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4A35F112.7010506@cn.fujitsu.com>
In-Reply-To: <4A35F112.7010506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152013.24686.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 04:28:26 pm Li Zefan wrote:
> Remove open-coded zalloc_cpumask_var() and zalloc_cpumask_var_node().

Thanks, applied.

Rusty.
