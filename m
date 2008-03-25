Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYCYEPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYCYEPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYCYEPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:15:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756746AbYCYEPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:15:33 -0400
Date: Mon, 24 Mar 2008 21:15:32 -0700 (PDT)
Message-Id: <20080324.211532.33163290.davem@davemloft.net>
To: paulus@samba.org
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <18408.29107.709577.374424@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
	<20080324.133722.38645342.davem@davemloft.net>
	<18408.29107.709577.374424@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Tue, 25 Mar 2008 14:29:55 +1100

> The performance advantage of using hardware 64k pages is pretty
> compelling, on a wide range of programs, and particularly on HPC apps.

Please read the rest of my responses in this thread, you
can have your HPC cake and eat it too.
