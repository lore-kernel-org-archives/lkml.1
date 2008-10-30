Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYJ3Vfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYJ3Vfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYJ3Vfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:35:31 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:48617 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYJ3Vfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:35:30 -0400
Date: Thu, 30 Oct 2008 16:33:34 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Dave Chinner <david@fromorbit.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <20081030210826.GR17077@disturbed>
Message-ID: <Pine.LNX.4.64.0810301632030.3839@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
 <20081030210826.GR17077@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008, Dave Chinner wrote:

> What sort of validation/regression testing has this been through?

There were several tests run more than a year ago by me on large SGI 
machines. Then there was Solomita who did various tests and posts of 
the patchset over the last year.


