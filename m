Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYJ3PYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYJ3PYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJ3PY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:24:28 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:56548 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbYJ3PY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:24:27 -0400
Subject: Re: [PATCH] regulator: Use menuconfig in Kconfig
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hfxmeyvum.wl%tiwai@suse.de>
References: <s5hfxmeyvum.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 15:24:26 +0000
Message-Id: <1225380266.6883.31.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 15:57 +0100, Takashi Iwai wrote:
> Use menuconfig instead of flat configs so that you can disable/enable
> regulator items with one selection.  Also, use depends instead of
> reverse selections to make life easier, too.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 

Applied.

Thanks

Liam

