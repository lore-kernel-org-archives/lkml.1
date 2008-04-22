Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYDVH0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYDVH0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYDVHZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:25:52 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11525 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753299AbYDVHZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:25:51 -0400
Subject: Re: sched tree bisectability
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080421.203212.262634448.davem@davemloft.net>
References: <20080421.203212.262634448.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 09:25:48 +0200
Message-Id: <1208849148.7115.212.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 20:32 -0700, David Miller wrote:
> While trying to bisect a regression added by the sched tree merges
> today, I found the following gem that broke compilation mid-bisect:

Hmm, sorry about that - I try avoid these things :-/


