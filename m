Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338Ab0AMKPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0AMKPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301Ab0AMKPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:15:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:58059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab0AMKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:15:09 -0500
X-IronPort-AV: E=Sophos;i="4.49,267,1262581200"; 
   d="scan'208";a="79804800"
Subject: [GIT PULL] update paravirt after f443ff42 "x86: Sync 32/64-bit
 kernel_thread" and related
From: Ian Campbell <Ian.Campbell@citrix.com>
To: <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Christian Kujau <lists@nerdbynature.de>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 13 Jan 2010 10:15:06 +0000
Message-ID: <1263377706.16526.12062.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
  Linus Torvalds (1):
        Linux 2.6.33-rc4

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-x86/bugfixes

Cyrill Gorcunov (1):
      x86: kernel_thread -- initialize SS to a known state

Ian Campbell (1):
      xen: 64 bit kernel RPL should be 0.

 arch/x86/kernel/process.c |    2 ++
 arch/x86/xen/enlighten.c  |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)


