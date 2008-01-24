Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYAXUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYAXUDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYAXUDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:03:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43406 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYAXUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:03:36 -0500
Date: Thu, 24 Jan 2008 21:37:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <davidn@davidnewall.com>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080124203724.GA14852@one.firstfloor.org>
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798D10C.6090109@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The performance benefit is trivial,

That's actually not true when you're talking about potential cache misses.
Cache misses are very expensive.

-Andi

