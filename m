Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbXKZU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbXKZU45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXKZU4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:56:50 -0500
Received: from relay1.sgi.com ([192.48.171.29]:60220 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753864AbXKZU4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:56:49 -0500
Date: Mon, 26 Nov 2007 12:56:48 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
In-Reply-To: <20071126124024.e0170f12.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711261256340.25688@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <20071126111320.69d0aead.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
 <20071126124024.e0170f12.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Randy Dunlap wrote:

> ARCH_SELECT_MEMORY_MODEL depends on X86_32.  Is that too restrictive?

No. X86_64 only has one memory model.
