Return-Path: <linux-kernel-owner+w=401wt.eu-S936794AbXFGUjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936794AbXFGUjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXFGUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:38:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39743 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbXFGUi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:38:58 -0400
Date: Thu, 7 Jun 2007 22:40:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Massimo Maiurana <maiurana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix typos in Makefile
Message-ID: <20070607204001.GA16634@uranus.ravnborg.org>
References: <4665A7C8.9050707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4665A7C8.9050707@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 08:13:28PM +0200, Massimo Maiurana wrote:
> kxgettext fails generating pot file for um arch due to wrong filenames
> and related symlinks in Makefile. Fixed with the patch below.

Thanks Massimo.
Applied,

	Sam
