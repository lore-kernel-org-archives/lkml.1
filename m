Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYI3Q7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYI3Q7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYI3Q7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:59:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:44711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYI3Q7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:59:46 -0400
Message-ID: <48E25A6B.7060700@kernel.org>
Date: Wed, 01 Oct 2008 01:57:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Robert Krawitz <rlk@alum.mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu> <48E0824B.4010408@kernel.org> <200809291141.m8TBfxiU004269@dsl092-065-009.bos1.dsl.speakeasy.net> <48E234B8.4050009@kernel.org> <200809301422.m8UEMT2F026609@dsl092-065-009.bos1.dsl.speakeasy.net>
In-Reply-To: <200809301422.m8UEMT2F026609@dsl092-065-009.bos1.dsl.speakeasy.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Sep 2008 16:58:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Krawitz wrote:
>    Thanks.  And how much does the load cycle count increase per hour
>    without any adustment?
> 
> I didn't count it for a full hour (I put the workaround in place over
> a month ago); it looked like it was incrementing something between 2
> and 5 times per minute, as I recall.

Can you please measure it again and post the result?

Thanks.

-- 
tejun
