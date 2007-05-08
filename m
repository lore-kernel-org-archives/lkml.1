Return-Path: <linux-kernel-owner+w=401wt.eu-S934676AbXEHWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbXEHWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934658AbXEHWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:19:19 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:26667 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934566AbXEHWQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:16:59 -0400
X-YMail-OSG: ccRI1OsVM1kIFSSdVVqZyoUIvpt0nYz77gr2NgCWTlwKXj3c8tbzK9cGz11vXVPC64A1lYI5oQ--
Date: Tue, 8 May 2007 15:16:56 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
Message-ID: <20070508221656.GA6850@tuatara.stupidest.org>
References: <20070508185145.B9A8E1827261@tuatara.stupidest.org> <20070508221348.GC17482@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508221348.GC17482@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:13:48AM +0200, Andi Kleen wrote:

> Nope.  There already is a getcpu vsyscall. This is not needed.

The kbuild magic that checks for missing syscalls needs to be taught
about this then I take it?
