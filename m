Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYKKN75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYKKN75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYKKN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:59:49 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:52375 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYKKN7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:59:49 -0500
Date: Tue, 11 Nov 2008 07:58:43 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: Peter Zijlstra <peterz@infradead.org>, Frank Mayhar <fmayhar@google.com>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: <200811110120.04768.ioe-lkml@rameria.de>
Message-ID: <Pine.LNX.4.64.0811110758200.17129@quilx.com>
References: <1224694989.8431.23.camel@oberon> <Pine.LNX.4.64.0811100834500.21257@quilx.com>
 <1226328152.7685.192.camel@twins> <200811110120.04768.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Ingo Oeser wrote:

> I mean these CPUs are not on the same node, right?

Intels roadmap calls for 128 core cpus by 2015....

