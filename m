Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYGPMjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYGPMjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYGPMjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:39:46 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1127 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbYGPMjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:39:45 -0400
Date: Wed, 16 Jul 2008 15:36:12 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: s2disk: system powers up again after power off
Message-ID: <20080716123611.GA2532@deprecation.cyrius.com>
References: <20080715124733.GA4111@deprecation.cyrius.com> <3aa654a40807150605r6d6206delcd903aac58f6291d@mail.gmail.com> <200807152224.19559.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807152224.19559.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-07-15 22:24]:
> Please try to put "shutdown method = shutdown" into the s2disk's configuration
> file and see what happens in that case.

Yep, this work.

-- 
Martin Michlmayr
http://www.cyrius.com/
