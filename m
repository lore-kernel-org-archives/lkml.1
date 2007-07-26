Return-Path: <linux-kernel-owner+w=401wt.eu-S934519AbXGZRsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbXGZRsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935012AbXGZRri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:47:38 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59248 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934203AbXGZRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:37 -0400
Date: Thu, 26 Jul 2007 10:47:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] SLUB & freeing locks [was: Re: 2.6.23-rc1: known regressions
 with patches]
In-Reply-To: <20070726105009.GA7673@elte.hu>
Message-ID: <Pine.LNX.4.64.0707261047240.2374@schroedinger.engr.sgi.com>
References: <46A47940.7030801@googlemail.com> <20070726091048.GA7366@elte.hu>
 <1185441963.8197.67.camel@twins> <1185442353.8197.71.camel@twins>
 <20070726105009.GA7673@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


