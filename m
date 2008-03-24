Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYCXHY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYCXHY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 03:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYCXHYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 03:24:50 -0400
Received: from ozlabs.org ([203.10.76.45]:39762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYCXHYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 03:24:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18407.22329.130304.645554@cargo.ozlabs.ibm.com>
Date: Mon, 24 Mar 2008 18:24:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] mpc5200: fix incorrect compatible string for the
 mdio node
In-Reply-To: <1206156315-4734-1-git-send-email-grant.likely@secretlab.ca>
References: <1206156315-4734-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely writes:

> The MDIO node in the lite5200b.dts file needs to also claim compatibility
> with the older mpc5200 chip.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> Paul, this one should also go in for .26

OK, I'll put it in the powerpc-next branch.  Or did you mean it should
go in .25?

Paul.
