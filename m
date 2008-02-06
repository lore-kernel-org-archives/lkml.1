Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYBFS6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYBFS6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYBFS6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:58:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45844 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbYBFS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:58:15 -0500
Date: Wed, 6 Feb 2008 10:58:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: {2.6.22.y} quicklists must keep even off node pages on the
 quicklists until the TLB flush has been completed.
In-Reply-To: <20080206060256.GA3836@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0802061058030.25173@schroedinger.engr.sgi.com>
References: <6101e8c40802051306y24cc7740g4c75508035aaefd@mail.gmail.com>
 <20080206060256.GA3836@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Dhaval Giani wrote:

> Is this one also supposed to be backported?

Yes.

