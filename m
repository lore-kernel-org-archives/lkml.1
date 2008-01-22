Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYAVXBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYAVXBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbYAVXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:00:22 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40625 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758219AbYAVXAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:00:18 -0500
Date: Tue, 22 Jan 2008 15:00:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Increasing partial pages
In-Reply-To: <20080122223541.GR27250@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0801221458260.2271@schroedinger.engr.sgi.com>
References: <20080116195949.GO18741@parisc-linux.org>
 <Pine.LNX.4.64.0801161219050.9694@schroedinger.engr.sgi.com>
 <20080116214127.GA11559@parisc-linux.org> <Pine.LNX.4.64.0801161347160.11353@schroedinger.engr.sgi.com>
 <20080116221618.GB11559@parisc-linux.org> <Pine.LNX.4.64.0801161421240.12024@schroedinger.engr.sgi.com>
 <20080118191430.GD20490@parisc-linux.org> <Pine.LNX.4.64.0801221142330.27692@schroedinger.engr.sgi.com>
 <20080122223541.GR27250@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Matthew Wilcox wrote:

> I also don't understand the dependency tree -- you seem to be saying
> that we could apply patch 6 without patches 1-5 and test that.

You could do that. Many patches can be moved at will, some require minor 
mods to apply.
