Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbZAPRgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbZAPRgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbZAPRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:35:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZAPRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:35:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=WbGqsMoX17z8aKz3831aHv/xLvpHNawNSBZRDPfJyKIehEFP2WOopVNHf7sQHbl5k
	4hjwPzeMhQhYD9CmNANWQ==
MIME-Version: 1.0
In-Reply-To: <20090113132714.75c9ed96@hyperion.delvare>
References: <20090113132714.75c9ed96@hyperion.delvare>
Date: Fri, 16 Jan 2009 09:35:45 -0800
Message-ID: <33307c790901160935v2495615fo4ee0998d348fa117@mail.gmail.com>
Subject: Re: Bugzilla permissions
From: Martin Bligh <mbligh@google.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: bugme-admin@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: mbligh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dear bugzilla admin,

Please send bugzilla admin emails to bugme-admin@linux-foundation.org
(is linked from the front page of http://bugzilla.kernel.org). Sorry, I can't
keep up with reading all of LKML nowadays ;-)

> Could you please unlock bugzilla so that everybody (starting with me)
> is allowed to change the attachment types? I am a bit tired of having
> to e-mail the person who created the attachment to ask him/her to
> change the type from application/octet-stream to text/plain so that I
> can see the attachment directly in my web browser. If we want people to
> help with bugs, we must make it as easy for them as possible.

Given that there's no real control on bugzilla accounts, I'm somewhat
reluctant to make it a complete free for all and let any new user edit
any bug. However, for anyone running a subsystem, or anyone else
that I have a vague clue who they are (or any established developer
will vouch for, anyone I can see git commits for, etc), I am perfectly
willing to enable global edit on a individual basis. Hasn't been a big
problem up until now, so I suspect it won't turn into one.

I enabled your account. Thanks for looking at bugs ;-)

M.
