Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZLAGp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZLAGp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZLAGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:45:57 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51109 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZLAGp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:45:57 -0500
Message-ID: <4B14BBAB.90105@cs.helsinki.fi>
Date: Tue, 01 Dec 2009 08:46:03 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the percpu tree with the slab tree
References: <20091201174349.f72f36bd.sfr@canb.auug.org.au>
In-Reply-To: <20091201174349.f72f36bd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell kirjoitti:
> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in mm/slab.c
> between commit ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62 ("SLAB: Fix
> lockdep annotations for CPU hotplug") from the slab tree and commit
> 1871e52c76dd95895caeb772f845a1718dcbcd75 ("percpu: make percpu symbols
> under kernel/ and mm/ unique") from the percpu tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fixup looks good to me. Thanks, Stephen!

			Pekka
