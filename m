Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753279AbYLQRgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYLQRgB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYLQRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:35:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYLQRfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:35:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081217171800.GA5436@uranus.ravnborg.org>
References: <20081217171800.GA5436@uranus.ravnborg.org> <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org> <20081217170257.GE28946@ZenIV.linux.org.uk> 
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org, gerg@uclinux.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Date: Wed, 17 Dec 2008 17:35:31 +0000
Message-ID: <18669.1229535331@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> I will take a closer look at the mn10300 bits and send them to David
> in due time.

Al's MN10300 patches compile okay, though I'm not sure I fully agree with
them.  I need to think about that a bit.

David
