Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXLFJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXLFJrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLFJrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:47:17 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:30433 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbXLFJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:47:16 -0500
Date: Thu, 6 Dec 2007 10:47:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] Text Edit Lock for 2.6.24-rc4-git3
Message-ID: <20071206094712.GB10455@osiris.boeblingen.de.ibm.com>
References: <20071206020246.417605824@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206020246.417605824@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:02:46PM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> Here is a repost of the text edit lock for 2.6.24-rc4-mm3. It is useful to
> coordinate modification of live kernel code patching.
> 
> It includes a modification to kprobes (its first user) and is useful for the
> Immediate Values.
> 
> It could be interesting to queue it for 2.6.25.

Everytime I see your huge patchset I'm wondering what it is good for and
give up since the patch set is large. It would be very helpful if your
patch descriptions would not only describe what you do but also why you
do it.
