Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbYD1TfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbYD1TfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbYD1Tel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:34:41 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:63738 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbYD1Tek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:34:40 -0400
Message-ID: <481626B6.5040207@aknet.ru>
Date: Mon, 28 Apr 2008 23:34:14 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv>
In-Reply-To: <20080427042331.GB29127@anvil.corenet.prv>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dmitry Torokhov wrote:
> It looks like the change was introduced by commit
> 67926892ef7a7fbc76de607120d44416019fdf07
Indeed. But the log message
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg36026.html
doesn't seem to specify the reason
for the change, so this doesn't
clarify a thing, unfortunately.

> I think that we should register devices even if there is no driver in
> the kernel for it because driver may be compiled at later time or be out
> of tree. Adding patch author and other people that signed off the patch
> to CC...
Since there seem to be no objections,
would you mind adding the patch to your
git tree? Or who should that be?
