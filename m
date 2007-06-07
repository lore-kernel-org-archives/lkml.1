Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXFGISA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXFGISA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXFGIRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:17:44 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60684 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbXFGIRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:17:42 -0400
Date: Thu, 7 Jun 2007 10:13:42 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Miloslav Trmac <mitr@redhat.com>
cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       Alexander Viro <aviro@redhat.com>
Subject: Re: [PATCH] Audit: Add TTY input auditing
In-Reply-To: <4666832D.8080603@redhat.com>
Message-ID: <Pine.LNX.4.61.0706071010510.1547@yvahk01.tjqt.qr>
References: <4666832D.8080603@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6 2007 11:49, Miloslav Trmac wrote:
>From: Miloslav Trmac <mitr@redhat.com>
>
>Add TTY input auditing, used to audit system administrator's actions.

_What_ exactly does it audit?
And why does it only audit sysadmin actions?
Is this supposed to be a keylogger?

>TTY input auditing works on a higher level than auditing all system

What about tty output?

>calls within the session, which would produce an overwhelming amount of
>mostly useless audit events.
>

	Jan
-- 
