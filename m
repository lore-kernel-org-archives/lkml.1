Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbZF2UOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbZF2UOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZF2UOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:14:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53282
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZF2UOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:14:40 -0400
Date: Mon, 29 Jun 2009 13:14:45 -0700 (PDT)
Message-Id: <20090629.131445.77994386.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, arnd@arndb.de, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: Move of_node_to_nid to generic location
From: David Miller <davem@davemloft.net>
In-Reply-To: <fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com>
References: <4A4884D6.3090404@monstr.eu>
	<fa686aa40906290852g42f55390tae7148e08fb8efe3@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 29 Jun 2009 09:52:44 -0600

> On Mon, Jun 29, 2009 at 3:09 AM, Michal Simek<monstr@monstr.eu> wrote:
>> This function is used for powerpc, sparc, microblaze (and maybe future arm?)
> 
> PowerPC uses it.  Other than that I don't know.

Sparc64 definitely uses it.
