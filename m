Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXJXDxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXJXDxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXJXDxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:53:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45172
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbXJXDxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:53:12 -0400
Date: Tue, 23 Oct 2007 20:52:56 -0700 (PDT)
Message-Id: <20071023.205256.48531415.davem@davemloft.net>
To: 12o3l@tiscali.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unlock before return in p9_mux_poll_start
From: David Miller <davem@davemloft.net>
In-Reply-To: <471D4B79.2070500@tiscali.nl>
References: <471D4B79.2070500@tiscali.nl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>
Date: Tue, 23 Oct 2007 03:16:41 +0200

> commit 9f822afc65cc094c905901f9d92bf25042f9ed22
> Author: Roel Kluin <12o3l@tiscali.nl>
> Date:   Tue Oct 23 03:15:55 2007 +0200
> 
>     Unlock before return in p9_mux_poll_start
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Applied, thanks!
