Return-Path: <linux-kernel-owner+w=401wt.eu-S1161230AbXBUNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230AbXBUNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXBUNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:37:04 -0500
Received: from twin.jikos.cz ([213.151.79.26]:49652 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161230AbXBUNg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:36:58 -0500
Date: Wed, 21 Feb 2007 14:35:48 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Adrian Bunk <bunk@stusta.de>
cc: Jiri Kosina <jkosina@suse.cz>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/hid/hid-debug.c should #include <linux/hid-debug.h>
In-Reply-To: <20070221115730.GG13958@stusta.de>
Message-ID: <Pine.LNX.4.64.0702211435430.10496@twin.jikos.cz>
References: <20070221115730.GG13958@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Adrian Bunk wrote:

> Every file should include the headers containing the prototypes for
> it's global functions.

Applied, thanks.

-- 
Jiri Kosina
