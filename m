Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZFECWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZFECWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZFECWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:22:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZFECWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:22:41 -0400
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20090604103909.GA10102@uranus.ravnborg.org>
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain>
	 <20090604091519.GA9571@uranus.ravnborg.org> <4A27927E.9090800@redhat.com>
	 <20090604103909.GA10102@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 07:53:44 +0530
Message-Id: <1244168624.2522.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 12:39 +0200, Sam Ravnborg wrote:

> So if you touch this I would ask you not to consider a single line
> in jffs-user.h - but rather take a critiacal look at the whole
> file and fix any issues there is.
> And then to send it to the mtd people (dwmw2).
> I did not look at the file but just looking at yout patch
> the "undef jemode_to_cpu" looks fishy in an exported header.
> 

David already have patches to remove whole jffs-user.h file and AFAIK he
already queued it. So no point of touching this file.

Thanks,
--
JSR

