Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbXGQJLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbXGQJLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXGQJK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:10:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57961 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXGQJKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:10:55 -0400
Date: Tue, 17 Jul 2007 11:12:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modpost white list pattern adjustment
Message-ID: <20070717091209.GA19679@uranus.ravnborg.org>
References: <466E6785.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E6785.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 09:29:41AM +0200, Jan Beulich wrote:
> gcc puts data into .data.rel or .data.rel.* on some architectures (e.g.
> ia64) or under certain conditions, so whatever is legal relative to
> .data should also be legal for those other sections. Fixes a few
> modpost warnings on ia64.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied.

	Sam
