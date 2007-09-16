Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbXIPLGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbXIPLGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 07:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXIPLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 07:06:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47600 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbXIPLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 07:06:33 -0400
Date: Sun, 16 Sep 2007 13:07:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tristate choices with mixed tristate and boolean values
Message-ID: <20070916110755.GA7265@uranus.ravnborg.org>
References: <46E55B7A.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E55B7A.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 01:58:02PM +0100, Jan Beulich wrote:
> Change kconfig behavior so that mixing bool and tristate config
> settings in a choice is possible and has the desired effect of
> offering just the tristate options individually if the choice gets set
> to M, and a normal boolean selection if the choice gets set to Y.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied after fixing whitespace issue (spaces -> tabs)

	Sam
