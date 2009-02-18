Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZBRMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZBRMbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZBRMbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:31:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:55382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZBRMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:31:11 -0500
Subject: Re: [PATCH v2] perfcounters: clean up rotate_percpu
From: Peter Zijlstra <peterz@infradead.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090218212730.dde6942b.minchan.kim@barrios-desktop>
References: <20090218212730.dde6942b.minchan.kim@barrios-desktop>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:31:07 +0100
Message-Id: <1234960267.4637.62.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 21:27 +0900, MinChan Kim wrote:
> Ingo implemented rotate function at 235c7fc7c500e4fd1700c4ad01b5612bcdc1b449.
> I think he want to implement rotate_percpu but he don't implement it yet.
> 
> If we need not it immediately,
> It would be better to remove it until we will need it again.

It seems to me, a more constructive patch would be to implement it for
him.

