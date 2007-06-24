Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbXFXU1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbXFXU1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXFXU1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:27:47 -0400
Received: from lucidpixels.com ([75.144.35.66]:58988 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXFXU1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:27:47 -0400
Date: Sun, 24 Jun 2007 16:27:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Intel MTRR Patch
Message-ID: <Pine.LNX.4.64.0706241627130.5819@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still patches clean against 2.6.22-rc5 incase anyone wanted to know:

# patch -p1 < ../mtrr-v2.patch
patching file Documentation/kernel-parameters.txt
patching file arch/i386/kernel/cpu/mtrr/generic.c
patching file arch/i386/kernel/cpu/mtrr/if.c
patching file arch/i386/kernel/cpu/mtrr/main.c
patching file arch/i386/kernel/cpu/mtrr/mtrr.h
patching file arch/x86_64/kernel/bugs.c
patching file arch/x86_64/kernel/setup.c
patching file include/asm-x86_64/mtrr.h

