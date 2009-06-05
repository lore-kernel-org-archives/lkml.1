Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZFEVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZFEVjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZFEVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:39:11 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60854 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbZFEVjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:39:08 -0400
Date: Fri, 5 Jun 2009 23:41:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch] kbuild: clean up scripts/headers.sh
Message-ID: <20090605214125.GB29008@uranus.ravnborg.org>
References: <20090605021419.7905.89870.sendpatchset@localhost.localdomain> <20090605021427.7905.16640.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605021427.7905.16640.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 10:12:09PM -0400, Amerigo Wang wrote:
> 
> 'drop' variable is unused.
> 
> 'ppc' and 'sparc64' directories don't exist in arch/,
> and I think their headers can be well exported now, so
> just remove them.

Applied,
	Sam
