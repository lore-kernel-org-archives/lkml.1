Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZGNKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZGNKeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZGNKeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:34:18 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62929 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbZGNKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:34:17 -0400
Subject: Re: kmemleak hexdump proposal
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090714103356.GA2929@localdomain.by>
References: <20090629201014.GA5414@localdomain.by>
	 <1247566033.28240.46.camel@pc1117.cambridge.arm.com>
	 <20090714103356.GA2929@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 11:34:01 +0100
Message-Id: <1247567641.28240.51.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 10:34:02.0611 (UTC) FILETIME=[9AF48430:01CA046E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 13:33 +0300, Sergey Senozhatsky wrote:
> On (07/14/09 11:07), Catalin Marinas wrote:
> Am I understand correct that no way for user to on/off hexdump?
> /* no need for atomic_t kmemleak_hex_dump */

Yes. Two lines aren't really too much so we can always have them
displayed.

-- 
Catalin

