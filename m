Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZEDSMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZEDSMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZEDSLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:11:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52010
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755781AbZEDSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:11:52 -0400
Date: Mon, 04 May 2009 11:11:47 -0700 (PDT)
Message-Id: <20090504.111147.124526771.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] netns 1/2: don't get/put old netns on CLONE_NEWNET
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090503232825.GF16631@x200.localdomain>
References: <20090503232825.GF16631@x200.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 4 May 2009 03:28:25 +0400

> copy_net_ns() doesn't copy anything, it creates fresh netns, so get/put of old
> netns isn't needed.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Applied to net-next-2.6
