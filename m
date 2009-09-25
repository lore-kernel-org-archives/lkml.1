Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbZIYCbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbZIYCbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZIYCby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:31:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49685 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZIYCbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:31:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v7][PATCH 9/9]: Document clone2() syscall
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
In-Reply-To: <20090924170331.GI16989@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com> <20090924170331.GI16989@us.ibm.com>
Message-Id: <20090925113034.C145.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Sep 2009 11:31:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> Subject: [RFC][v7][PATCH 9/9]: Document clone2() syscall
> 
> This gives a brief overview of the clone2() system call.  We should
> eventually describe more details in existing clone(2) man page or in
> a new man page.
> 
> Changelog[v7]:
> 	- Rename clone_with_pids() to clone2()
> 	- Changes to reflect new prototype of clone2() (using clone_struct).
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@vnet.linux.ibm.com>

AFAIK, ia64 already have clone2() systemcall and it is imcompatible this.




