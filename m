Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbYEBBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbYEBBO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYEBBOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:14:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753676AbYEBBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:14:52 -0400
Date: Thu, 1 May 2008 18:14:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] SLQB v2
In-Reply-To: <20080502004325.GA30768@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0805011813180.13527@schroedinger.engr.sgi.com>
References: <20080410193137.GB9482@wotan.suse.de> <20080415034407.GA9120@ubuntu>
 <20080501015418.GC15179@wotan.suse.de> <Pine.LNX.4.64.0805011226410.8738@schroedinger.engr.sgi.com>
 <20080502004325.GA30768@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Nick Piggin wrote:

> If you are not debugging sl?b.c code/pages, then why would you want to see
> what those fields are?

Because you are f.e. inspecting a core dump and want to see why certain 
fields have certain values to verify that the structures were not 
overwrittten or corrupted etc.


 
