Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYLDWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYLDWkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYLDWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:40:37 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:43132 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbYLDWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:40:37 -0500
Date: Thu, 4 Dec 2008 23:40:22 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Dan =?unknown-8bit?Q?No=C3=A9?= <dpn@isomerica.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc failures under network/disk IO load
Message-ID: <20081204224021.GA323@electric-eye.fr.zoreil.com>
References: <20081203222750.391e8890@tuna> <1228378983.5092.7.camel@twins> <1228380128.5092.15.camel@twins> <20081204135443.7c24234a@rockhopper.limebrokerage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081204135443.7c24234a@rockhopper.limebrokerage.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Noé <dpn@isomerica.net> :
[...]
> I'm a bit confused because on another system (2.6.26.3) I never see
> messages like this despite having the same amount of physical RAM in
> each.  The 2.6.26.3 system is also under more active use, and has more
> userspace memory usage.  On that system:

Does this system use the same network card ?

-- 
Ueimor
