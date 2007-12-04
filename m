Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXLDVef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXLDVef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXLDVe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:34:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXLDVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:34:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dsmith@redhat.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] Linux Kernel Markers - Create modpost file
In-Reply-To: Mathieu Desnoyers's message of  Tuesday, 4 December 2007 14:15:28 -0500 <20071204191528.GA31752@Krystal>
References: <20071204181845.895090222@polymtl.ca>
	<20071204182403.319351701@polymtl.ca>
	<20071204111026.9f7d8ed5.akpm@linux-foundation.org>
	<20071204191528.GA31752@Krystal>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071204213413.171D826F8A0@magilla.localdomain>
Date: Tue,  4 Dec 2007 13:34:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why was the mystery addition of _GNU_SOURCE made?
> 
> I think Roland needed it for asprintf().

That's correct.


Thanks,
Roland
