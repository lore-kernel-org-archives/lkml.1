Return-Path: <linux-kernel-owner+w=401wt.eu-S936800AbXHHQgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936800AbXHHQgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935337AbXHHQfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:35:12 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:32203 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936708AbXHHQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:35:09 -0400
Date: Wed, 8 Aug 2007 18:35:43 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
Message-ID: <20070808183543.3b271c31@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>
	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>
	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>
	<46B9D4B8.4050201@gmail.com>
	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 16:50:27 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Wed, 08 Aug 2007 23:35:36 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > Does the attached patch happen to fix the problem?
> 
> Indeed it does; thanks!

And the whole patchset seems to work as well. I did my usual
attach/detach/move stuff, and didn't see any problems.
