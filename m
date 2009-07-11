Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZGKNm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZGKNm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 09:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGKNmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 09:42:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZGKNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 09:42:19 -0400
Subject: Re: Suggested code change : Simple : Scale pdflush threads from
 desktop to server
From: Peter Zijlstra <peterz@infradead.org>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
References: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 15:42:14 +0200
Message-Id: <1247319734.9978.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 18:25 -0700, Mitchell Erblich wrote:
> Group,
> 
> 		pdflush threads clean dirty pages

pdflush will very soon be gone, so tinkering with it is an utter waste
of time imho.

