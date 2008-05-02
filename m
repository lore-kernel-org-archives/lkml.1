Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbYEBLIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbYEBLIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYEBLIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:08:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37781
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933371AbYEBLIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:08:40 -0400
Date: Fri, 02 May 2008 04:08:39 -0700 (PDT)
Message-Id: <20080502.040839.145743195.davem@davemloft.net>
To: den@openvz.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@openvz.org, ebiederm@xmission.com, chas@cmf.nrl.navy.mil
Subject: Re: [PATCH 5/12] atm: assign PDE->data before gluing PDE into
 /proc tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209467602-20001-5-git-send-email-den@openvz.org>
References: <1209467538.29647.11.camel@iris.sw.ru>
	<1209467602-20001-5-git-send-email-den@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@openvz.org>
Date: Tue, 29 Apr 2008 15:13:15 +0400

> Simply replace proc_create and further data assigned with proc_create_data.
> proc_atm_dev_ops holds proper referrence.
> 
> Signed-off-by: Denis V. Lunev <den@openvz.org>

Applied.
