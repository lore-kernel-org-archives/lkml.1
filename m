Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZI2CE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZI2CE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZI2CE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:04:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56178 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZI2CE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:04:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Sep 2009 11:02:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dulloor <dulloor@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per-process flags on x86
Message-Id: <20090929110221.565781f4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <940bcfd20909272333g10e298m8f6271c80462cb7c@mail.gmail.com>
References: <940bcfd20909272333g10e298m8f6271c80462cb7c@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 02:33:49 -0400
Dulloor <dulloor@gmail.com> wrote:

> The flags field in task_struct is exhausted (for x86). Would it be
> acceptable to add another flag (in the same cache line) ?
> 
I think it depends on your purpose. talk-by-patch is maybe good.
Several people will have their own suggestion.

Thanks,
-Kame

