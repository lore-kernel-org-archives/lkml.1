Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXDVVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXDVVtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 17:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXDVVtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 17:49:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46881 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXDVVts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 17:49:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] sas_scsi_host: Convert to use the kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695611073-git-send-email-ebiederm@xmission.com>
	<20070419173753.8ba2f955.akpm@linux-foundation.org>
	<20070422193843.GA17841@infradead.org>
	<1177277868.4268.16.camel@mulgrave.il.steeleye.com>
Date: Sun, 22 Apr 2007 15:48:05 -0600
In-Reply-To: <1177277868.4268.16.camel@mulgrave.il.steeleye.com> (James
	Bottomley's message of "Sun, 22 Apr 2007 16:37:48 -0500")
Message-ID: <m1k5w4ytbe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> writes:

> Changelog and cc to linux-scsi, and I think it can go in ... not that it
> matters; nothing ever activates this code inside libsas anyway ...

Should we just remove the relevant code then?

Eric
