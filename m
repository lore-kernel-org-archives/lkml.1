Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXJQOF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXJQOF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJQOFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:05:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXJQOFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:05:14 -0400
Subject: Re: [PATCH 4/4] fix not-and/or errors
From: Peter Zijlstra <peterz@infradead.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47161451.9010309@tiscali.nl>
References: <47161243.6060007@tiscali.nl>  <47161451.9010309@tiscali.nl>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 16:05:10 +0200
Message-Id: <1192629910.27435.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 15:55 +0200, Roel Kluin wrote:
> if(!x & y) should either be if(!(x & y)) or if(!x && y)
>     I made changes as seemed appropriate, but please review
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

and 3 and 4 look good too..

