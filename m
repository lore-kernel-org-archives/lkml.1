Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYGKPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYGKPis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYGKPii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:38:38 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2526 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbYGKPih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:38:37 -0400
Date: Fri, 11 Jul 2008 18:38:16 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Message-ID: <20080711153815.GA7109@deprecation.cyrius.com>
References: <1214584985.22228.15.camel@localhost> <20080709130823.GA21320@deprecation.cyrius.com> <200807092300.59678.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092300.59678.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-07-09 23:00]:
> This is a symptom of the userspace resume trying to feed invalid image
> metadata to the kernel (yes, I'll have to change that code to return error
> code in that case).
> 
> Please try to run mkswap on your resume partition and see if that helps.

Nope, I'm still getting the same.
-- 
Martin Michlmayr
http://www.cyrius.com/
