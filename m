Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507AbYANTs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbYANTs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYANTsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:48:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53809 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbYANTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:48:18 -0500
Date: Mon, 14 Jan 2008 11:48:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: cleanup setup_node_zones called by paging_init
 v2
In-Reply-To: <200801120326.25688.yinghai.lu@sun.com>
Message-ID: <Pine.LNX.4.64.0801141147520.8300@schroedinger.engr.sgi.com>
References: <200801081934.33964.yinghai.lu@sun.com> <200801091030.40545.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801091117430.11317@schroedinger.engr.sgi.com>
 <200801120326.25688.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008, Yinghai Lu wrote:

> please check the following patch.

Exactly!

Reviewed-by: Christoph Lameter <clameter@sgi.com>
