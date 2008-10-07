Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYJGXgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYJGXgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYJGXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:36:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbYJGXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:36:22 -0400
Date: Wed, 8 Oct 2008 01:42:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space II
Message-ID: <20081007234230.GA7971@one.firstfloor.org>
References: <20081007143.793379346@firstfloor.org> <48EBD555.9060104@kernel.org> <20081007231149.GT20740@one.firstfloor.org> <48EBEFCC.4090302@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EBEFCC.4090302@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW even if you cannot get yourself to DTRT on the user interface please at
least apply the followup cleanup patches in the series.

-Andi

-- 
ak@linux.intel.com
