Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbYEWSHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbYEWSHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEWSHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:07:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYEWSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:07:35 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080523164108.GA31545@uranus.ravnborg.org>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <1211550374.28967.10.camel@pmac.infradead.org>
	 <20080523164108.GA31545@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 19:07:30 +0100
Message-Id: <1211566051.28967.73.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Er, is this my fault or was it like this already...

pmac /pmac/git/linux-2.6 $ make O=/pmac/git/foo 
  GEN     /pmac/git/foo/Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
gcc: /pmac/git/linux-2.6/scripts/kconfig/zconf.tab.c: No such file or directory
gcc: no input files

-- 
dwmw2

