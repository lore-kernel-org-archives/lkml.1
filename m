Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbZGBUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbZGBUSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZGBUS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:18:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38084
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbZGBUS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:18:27 -0400
Date: Thu, 02 Jul 2009 13:18:33 -0700 (PDT)
Message-Id: <20090702.131833.250097602.davem@davemloft.net>
To: adkulkar@umail.iu.edu
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [9P PATCH 2/2] net/9p: Fix crash due to bad mount parameters.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1246474254-10401-2-git-send-email-adkulkar@umail.iu.edu>
References: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
	<1246474254-10401-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Date: Wed,  1 Jul 2009 12:50:54 -0600

> It is not safe to use match_int without checking the token type returned
> by match_token (especially when the token type returned is Opt_err and
> args is empty). Fix it.
> 
> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>

Applied.
