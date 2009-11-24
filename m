Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbZKXVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbZKXVeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934008AbZKXVeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:34:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33200 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbZKXVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:34:19 -0500
Date: Tue, 24 Nov 2009 22:34:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091124213422.GC29096@one.firstfloor.org>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com> <20091124212619.GB29096@one.firstfloor.org> <20091124213105.GG29296@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124213105.GG29296@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One man's obfuscation is another man's abstraction.
> Would you be satisfied if "tracehook_" was renamed "utracehook_"?

I would prefer if there were no thin inlines, and the functions should
have a name clearly indicating for which subsystem they are for.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
