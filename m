Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbYCCR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbYCCR5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYCCR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:57:10 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57552 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753460AbYCCR5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:57:09 -0500
Date: Mon, 3 Mar 2008 09:57:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 07/10] Pageflags: Get rid of FLAGS_RESERVED
In-Reply-To: <20080301112600.4e01c3a2@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0803030956210.6010@schroedinger.engr.sgi.com>
References: <20080301040534.797979115@sgi.com> <20080301040621.484085808@sgi.com>
 <20080301112600.4e01c3a2@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Rik van Riel wrote:

> Did part of your automatically generated file just leak into the patch
> series?

Some setting is necessary for kernel/bounds.c to compile. Value will be 
updated with the current value.

