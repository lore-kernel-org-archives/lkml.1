Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbXJTTPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbXJTTPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 15:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbXJTTP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 15:15:27 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40835 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbXJTTP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 15:15:26 -0400
Date: Sat, 20 Oct 2007 21:17:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Henrik Carlqvist <hc1@poolhem.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-ID: <20071020191700.GB8774@uranus.ravnborg.org>
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020144238.4f258c8c.hc1@poolhem.se>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 02:42:38PM +0200, Henrik Carlqvist wrote:
> I think there is a need for Kconfig to specify that a functionality could
> be built as a module or not built at all.

I assume
	depends on MODULES

should do the trick.

	Sam
