Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZEVGbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZEVGbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVGa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:30:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57181
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508AbZEVGa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:30:56 -0400
Date: Thu, 21 May 2009 23:30:54 -0700 (PDT)
Message-Id: <20090521.233054.46785912.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, torvalds@linux-foundation.org,
       xemul@parallels.com, orenl@cs.columbia.edu, serue@us.ibm.com,
       dave@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [PATCH 10/38] netns 2/2: extract net_create()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1242968132-1044-10-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	<1242968132-1044-10-git-send-email-adobriyan@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 22 May 2009 08:55:04 +0400

> net_create() will be used by C/R to create fresh netns on restart.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
