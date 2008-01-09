Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYAIRtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYAIRtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 12:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYAIRtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 12:49:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47584 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752301AbYAIRtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 12:49:04 -0500
Date: Wed, 9 Jan 2008 09:49:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: cleanup setup_node_zones called by paging_init
In-Reply-To: <200801081934.33964.yinghai.lu@sun.com>
Message-ID: <Pine.LNX.4.64.0801090947570.10163@schroedinger.engr.sgi.com>
References: <200801081934.33964.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Yinghai Lu wrote:

> [PATCH] x86_64: cleanup setup_node_zones called by paging_init

The whitespace cleanups make it difficult to review the patch. Could you 
send those separately?

