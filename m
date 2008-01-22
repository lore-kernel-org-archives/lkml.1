Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYAVDHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYAVDHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbYAVDEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:04:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254AbYAVDEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:04:43 -0500
Date: Mon, 21 Jan 2008 19:04:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] sh: termios ioctl definitions
Message-Id: <20080121190453.16b03a81.akpm@linux-foundation.org>
In-Reply-To: <20080119160506.5aab8000@lxorguk.ukuu.org.uk>
References: <20080119160506.5aab8000@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jan 2008 16:05:06 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> These ports are holding up progress and now have been for months. Do the
> job for them.

Never understood the dependencies here.  Do these two patches depend on something
else which is only-in-mm?

Also, I've been uncertainly sitting on
http://userweb.kernel.org/~akpm/mmotm/broken-out/tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
for some time.  Is it ready to go into git-x86?

Thanks.
