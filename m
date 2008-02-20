Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbYBTSQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbYBTSQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYBTSQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:16:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYBTSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:16:41 -0500
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
In-Reply-To: <20080219123756.6261c13c@laptopd505.fenrus.org>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 19:16:15 +0100
Message-Id: <1203531375.6243.52.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-19 at 12:37 -0800, Arjan van de Ven wrote:
> From: Soren Sandmann <sandmann@redhat.com>
> Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> 
> The sysprof tool is a very easy to use GUI tool to find out where
> userspace is spending CPU time. See
> http://www.daimi.au.dk/~sandmann/sysprof/
> for more information and screenshots on this tool.
> 
> Sysprof needs a 200 line kernel module to do it's work, this
> module puts some simple profiling data into debugfs.

What is the added value over oprofile?

