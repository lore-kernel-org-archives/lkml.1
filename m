Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYFIVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYFIVPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYFIVPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:15:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57801 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752684AbYFIVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:15:29 -0400
Date: Mon, 9 Jun 2008 14:15:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v6
In-Reply-To: <20080609210344.GA9039@sgi.com>
Message-ID: <Pine.LNX.4.64.0806091414440.8657@schroedinger.engr.sgi.com>
References: <20080609161933.GC14939@sgi.com>
 <Pine.LNX.4.64.0806091123400.30605@schroedinger.engr.sgi.com>
 <20080609210344.GA9039@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Russ Anderson wrote:

> Does this look better?

Excellent.

Reviewed-by: Christoph Lameter <clameter@sgi.com>

