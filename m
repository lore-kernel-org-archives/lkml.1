Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYLVIqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYLVIqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 03:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYLVIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 03:45:57 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:32916 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYLVIpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 03:45:55 -0500
Subject: Re: [PATCH 1/13] s390: Remove redundant test
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Julia Lawall <julia@diku.dk>
Cc: heiko.carstens@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812211628030.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211628030.9555@pc-004.diku.dk>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 22 Dec 2008 09:44:54 +0100
Message-Id: <1229935495.1529.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-21 at 16:28 +0100, Julia Lawall wrote:
> The loop above the modified code only terminates when rc is a valid pointer.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

Purely cosmetic but simplifies the code. So yes, makes sense.
Added to the s390 patch queue. Thanks Julia.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


