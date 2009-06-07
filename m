Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZFGJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZFGJXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFGJXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:23:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35968 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbZFGJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:23:12 -0400
Subject: Re: [PATCH v2.1 10/17] JFFS2: do not manipulate s_dirt directly
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1244273108.3751.1029.camel@macbook.infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
	 <1244207155-2092-11-git-send-email-dedekind@infradead.org>
	 <1244273108.3751.1029.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Jun 2009 12:21:57 +0300
Message-Id: <1244366517.5847.318.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 Jun 2009 09:21:57.0732 (UTC) FILETIME=[67D79A40:01C9E751]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 08:25 +0100, David Woodhouse wrote:
> On Fri, 2009-06-05 at 16:05 +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > ... use new VFS helpers instead.
> > 
> > Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: linux-mtd@lists.infradead.org
> 
> Presumably this is intended for Al's tree rather than mine? I could
> massage it and apply it here, but then someone would just have to
> massage it back when they eventually get merged.
> 
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>

Thanks. Sure, this is for Al, I've just CCed FS maintainers to show them
the change.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

