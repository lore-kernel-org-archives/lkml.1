Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbYJSVZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbYJSVZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJSVZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:25:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:37706 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYJSVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:25:25 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 19 Oct 2008 14:25:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ben Castricum <lk0810@bencastricum.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer derefence since 2.6.27 in (e)poll
In-Reply-To: <C7D8EA1750C540FF84D4C36F414AD7C3@Seven>
Message-ID: <Pine.LNX.4.64.0810191423510.24074@alien.or.mcafeemobile.com>
References: <C7D8EA1750C540FF84D4C36F414AD7C3@Seven>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Ben Castricum wrote:

> On Sun, 19 Oct 2008, Hugh Dickins wrote:
> 
> > Isn't it the issue fixed by
> > 
> > http://marc.info/?l=linux-kernel&m=122428548613067&w=2
> 
> I am not sure, below is the latest bug message. My knowledge of git is very
> limited, how can I tell if this is before or after the patch?

You get the patch that is inside the message above, you apply it to the 
kernel source, you rebuild it, and see if it does it again.



- Davide


