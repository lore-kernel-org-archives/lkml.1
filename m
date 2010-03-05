Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0CEO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:57:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:45061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0CEO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:57:18 -0500
Subject: Re: [PATCH 1/1] perf tools: Don't trow away old map slices not
 overlapped by new maps
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1267800842-22324-1-git-send-email-acme@infradead.org>
References: <1267800842-22324-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 15:57:13 +0100
Message-ID: <1267801033.16716.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 11:54 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>

Ah, indeed, I only checked for overlaps, not punching holes.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

