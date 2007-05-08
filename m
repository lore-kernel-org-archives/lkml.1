Return-Path: <linux-kernel-owner+w=401wt.eu-S968310AbXEHQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968310AbXEHQIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934784AbXEHQIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:08:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47813 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934771AbXEHQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:08:29 -0400
Date: Tue, 8 May 2007 09:08:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vmstat-use-our-own-timer-events-fix
In-Reply-To: <735170251589527543@wsc.cz>
Message-ID: <Pine.LNX.4.64.0705080908080.8722@schroedinger.engr.sgi.com>
References: <46403B7F.1050009@gmail.com> <20070508021131.438cee31.akpm@linux-foundation.org>
 <20070508105528.GA86@tv-sign.ru> <46405A67.8020105@gmail.com>
 <46406656.9060504@gmail.com> <20070508134815.GA1074@tv-sign.ru>
 <20070508134815.GA1074@tv-sign.ru> <735170251589527543@wsc.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jiri Slaby wrote:

> Yes, it helped, thanks. If no objections, please apply the patch below.

Acked-by: Christoph Lameter <clameter@sgi.com>
