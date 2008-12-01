Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYLAOnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYLAOnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYLAOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:43:00 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:58289 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYLAOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:43:00 -0500
Date: Mon, 1 Dec 2008 08:40:58 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 8/8] badpage: KERN_ALERT BUG instead of KERN_EMERG
In-Reply-To: <Pine.LNX.4.64.0812010047010.11401@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010840110.15331@quilx.com>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010047010.11401@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Hugh Dickins wrote:
> And remove the "Trying to fix it up, but a reboot is needed" line:
> it's not untrue, but I hope the KERN_ALERT "BUG: " conveys as much.

Thanks. That was a pretty strange message....

