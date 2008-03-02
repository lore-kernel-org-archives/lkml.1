Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYCBHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYCBHDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 02:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYCBHDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 02:03:05 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53817 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbYCBHDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 02:03:04 -0500
To: linux-kernel@vger.kernel.org
Subject: How do arch/ppc and arch/powerpc differ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200803021602.EGJ81261.OJtOFVQFFHOSLM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 2 Mar 2008 16:02:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

According to Documentation/SubmitChecklist,
ppc64 is a good architecture for cross-compilation checking.
I've just set up cross compiling environment for ppc64
using "crossdev -t ppc64" on Gentoo 2007.0 environment.

Now I'm trying to modify Makefile to build kernel for ppc64.
I've got a question here.

  ARCH            ?= powerpc
  CROSS_COMPILE   ?= powerpc64-unknown-linux-gnu-

Which keyword ("ppc" or "powerpc") do I need to set for ARCH
to do cross-compilation checking?
How do they differ?

Regards.
