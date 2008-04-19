Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYDSOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYDSOHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYDSOHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:07:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55719 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbYDSOHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:07:22 -0400
Date: Sat, 19 Apr 2008 23:06:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC patch 16/27] Immediate Values Support init
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080419132435.GA19416@Krystal>
References: <20080419192334.A8FD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419132435.GA19416@Krystal>
Message-Id: <20080419230525.A903.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I prefer to add an ifdef CONFIG_IMMEDIATE to module.c to follow what I
> have already done previously. Defining this empty structure is a bit
> odd. Here is the updated patch.
> 
> Thanks for testing/reporting this.

OK.
I tested and confirmed your latest patch solved my reporting problem.

Thanks.


