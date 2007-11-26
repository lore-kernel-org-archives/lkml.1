Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbXKZVAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbXKZVAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXKZVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:00:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41404 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751919AbXKZVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:00:03 -0500
Date: Mon, 26 Nov 2007 13:00:03 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
In-Reply-To: <20071126124730.34c43da1.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <20071126111320.69d0aead.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
 <20071126124730.34c43da1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Randy Dunlap wrote:

> This patch allows allnoconfig to build cleanly.

Well this sortof works.

One can again select a memory model but there is only one to choose from.
It would be best if the memory model selection would not occur.

