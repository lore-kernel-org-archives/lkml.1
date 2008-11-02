Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYKBTRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYKBTRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYKBTRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:17:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:55288 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYKBTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:17:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Nov 2008 11:17:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Olaf van der Spek <olafvdspek@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll behaviour after running out of descriptors
In-Reply-To: <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811021117050.9451@alien.or.mcafeemobile.com>
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com> 
 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com> 
 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com> 
 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008, Olaf van der Spek wrote:

> On Sun, Nov 2, 2008 at 7:48 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > Why don't you grep for TIME_WAIT?
> 
> Because I don't have access to the test environment at the moment.

Here:

http://tinyurl.com/5ay86v



- Davide


