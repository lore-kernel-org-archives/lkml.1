Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXEJLay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXEJLay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEJLas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:30:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXEJLar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:30:47 -0400
Date: Thu, 10 May 2007 13:30:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: [discuss] pte_{ex,rd}protect
Message-ID: <20070510113045.GD14898@one.firstfloor.org>
References: <46430780.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46430780.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:52:32AM +0200, Jan Beulich wrote:
> Various architectures define these, but they aren't being used anywhere -
> candidates for removal? The more that (at least) on i386 and x86-64
> pte_exprotect() is not symmetrical to pte_exec() and pte_mkexec()...

They should be removed everywhere imho

-Andi
