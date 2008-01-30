Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbYA3QYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbYA3QYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYA3QYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:24:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50929 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbYA3QYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:24:32 -0500
Date: Wed, 30 Jan 2008 17:24:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][scripts/{genksyms/parse.c,kconfig/zconf.tab)_shipped] duplicate YYSTYPE_IS_TRIVIAL =>1st *_DECLARED
Message-ID: <20080130162433.GA24138@uranus.ravnborg.org>
References: <47A093D6.3000105@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A093D6.3000105@tiscali.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 04:12:22PM +0100, Roel Kluin wrote:
> Untested patch, please confirm it's the right fix.

First off - I do not see what problem you are trying to fix.
Second - this is generated files that we never manually edit.
If the generated files are wrong the tools to generate the files
should be fixed.

	Sam
