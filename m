Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbXKORPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbXKORPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759289AbXKORPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:15:44 -0500
Received: from mx.pathscale.com ([198.186.3.68]:48046 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758621AbXKORPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:15:43 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 12:15:43 EST
Date: Thu, 15 Nov 2007 09:10:33 -0800
From: Arthur Jones <arthur.jones@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: infinipath@qlogic.com, Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] QLogic InfiniPath: convert ipath_eep_sem to mutex
Message-ID: <20071115171033.GD5630@bauxite.pathscale.com>
References: <20071113184503.GE30483@traven> <adahcjozgur.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahcjozgur.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi roland,  thanks for picking this up...

On Wed, Nov 14, 2007 at 12:56:12PM -0800, Roland Dreier wrote:
> [ Forwarding to ipath entry from MAINTAINERS file... if someone from
>   Qlogic will ACK this, I'll add it to my tree for 2.6.25 - Roland ]
> 
> QLogic InfiniPath: convert the semaphore ipath_eep_sem to the mutex
> API
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Acked-by: Michael Albaugh <Michael.Albaugh@qlogic.com>
Tested-by: Arthur Jones <arthur.jones@qlogic.com>

arthur
