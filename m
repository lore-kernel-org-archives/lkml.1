Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbZCSXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbZCSXgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZCSXgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:36:07 -0400
Received: from silene.metacarta.com ([208.80.142.18]:60949 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbZCSXgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:36:06 -0400
Date: Thu, 19 Mar 2009 19:36:02 -0400 (EDT)
From: Joe Malicki <jmalicki@metacarta.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: chrisw@sous-sol.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Message-ID: <9317608.11305011237505761979.JavaMail.root@ouachita>
In-Reply-To: <1906769.11304931237505721331.JavaMail.root@ouachita>
Subject: Re: [PATCH] CRED: Fix check_unsafe_exec()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.80.142.151]
X-Mailer: Zimbra 5.0.9_GA_2533.UBUNTU6 (ZimbraWebClient - [unknown] (Linux)/5.0.9_GA_2533.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Hugh Dickins" <hugh@veritas.com> wrote:

> 
> Okay, unless we hear bad news from you later, I'll post the set of
> three
> patches (removing the files->count check, then my original fs->count
> one,
> plus David's comment) in a day or two, adding a few more Ccs.
> 
> Hugh

No failures on several machines after several days... I'm pretty
satisfied that the patches fixed the problem.

Thank you so much for your work on this!
Joe Malicki
