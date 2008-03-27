Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYC0Spv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYC0Spv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbYC0Spm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:45:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58265 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755133AbYC0Spl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:45:41 -0400
Date: Thu, 27 Mar 2008 11:43:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [x86] Stricter check in follow_huge_addr()
In-Reply-To: <20080327081318.GA15626@elte.hu>
Message-ID: <Pine.LNX.4.64.0803271142130.7531@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803262101060.2683@schroedinger.engr.sgi.com>
 <20080327081318.GA15626@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Ingo Molnar wrote:

> btw., what type of real-life problem does this address? Did this trigger 
> somewhere? (if yes, do you have any URLs i could put into the 
> changelog?)

Does not address any issues. I just saw it on review while thinking about 
how to optimize checks.

