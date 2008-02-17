Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYBQGHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYBQGHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 01:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYBQGH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 01:07:29 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:45345 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbYBQGH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 01:07:28 -0500
Date: Sun, 17 Feb 2008 15:06:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300 add sci.h
Message-ID: <20080217060606.GA7780@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
References: <878x1k2o0o.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878x1k2o0o.wl%ysato@users.sourceforge.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:41:11PM -0500, Yoshinori Sato wrote:
> This file require sh-sci
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
>  include/asm-h8300/sci.h |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-h8300/sci.h
> 
Let's just move it to include/linux instead of doing a 100% duplication
for H8..
