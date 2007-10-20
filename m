Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXJTSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXJTSwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbXJTSwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:52:12 -0400
Received: from www.tglx.de ([62.245.132.106]:37152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185AbXJTSwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:52:11 -0400
Date: Sat, 20 Oct 2007 20:52:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Gerst <bgerst@didntduck.org>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge required-features.h
In-Reply-To: <471A3DD5.4000501@didntduck.org>
Message-ID: <alpine.LFD.0.9999.0710202051270.22770@localhost.localdomain>
References: <471A3DD5.4000501@didntduck.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Brian Gerst wrote:

> Signed-off-by: Brian Gerst <bgerst@didntduck.org>
> ---
>  include/asm-x86/required-features.h    |   73 ++++++++++++++++++++++++++++++-
>  include/asm-x86/required-features_32.h |   55 ------------------------
>  include/asm-x86/required-features_64.h |   46 --------------------
>  3 files changed, 70 insertions(+), 104 deletions(-)
>  delete mode 100644 include/asm-x86/required-features_32.h
>  delete mode 100644 include/asm-x86/required-features_64.h

Applied, thanks.

	tglx
