Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYH0SNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYH0SNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYH0SNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:13:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59480 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYH0SNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:13:33 -0400
Date: Wed, 27 Aug 2008 11:04:57 -0700
From: sukadev@us.ibm.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pid_ns: kill the now unused task_child_reaper()
Message-ID: <20080827180457.GC4397@us.ibm.com>
References: <20080824154913.GA3786@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154913.GA3786@tv-sign.ru>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@tv-sign.ru] wrote:
| task_child_reaper() has no callers anymore, kill it.
| 
| Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
