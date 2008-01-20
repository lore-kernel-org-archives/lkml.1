Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYATVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYATVdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 16:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYATVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 16:33:33 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:32923 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbYATVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 16:33:32 -0500
Date: Sun, 20 Jan 2008 22:33:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
Subject: Re: kbuild: improved Section mismatch detection
Message-ID: <20080120213340.GA24526@uranus.ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120200527.GA23852@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 09:05:27PM +0100, Sam Ravnborg wrote:
> I have spent the last week (the time I can afford to
> Linux stuff anyway) to improve the Section mismatch 
> warnings detected by modpost.

Forgot to mention that all patches are made on top of
kbuild.git but I expect then to apply to mainline with
minimal effort.

They are all pushed out to the kbuild.git tree
for easy git retrival.

Please note that I often rebase kbuild.git
without any notice.

	Sam
