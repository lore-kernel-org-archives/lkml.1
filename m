Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZD0TYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZD0TYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZD0TYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:24:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZD0TYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:24:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090427180455.GA32509@redhat.com>
References: <20090427180455.GA32509@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       yasutake.koichi@jp.panasonic.com, linux-kernel@vger.kernel.org
Subject: Re: arch/ && tracehook_report_syscall_xxx()
Date: Mon, 27 Apr 2009 20:24:07 +0100
Message-ID: <22922.1240860247@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Hmm... and I can't understand how to change
> arch/mn10300/kernel/ptrace.c:do_syscall_trace(), it does something
> strange with TIF_SINGLESTEP. (maintainers cc'ed).

Leave that one to me.

David
