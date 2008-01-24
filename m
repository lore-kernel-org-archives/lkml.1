Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYAXMCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYAXMCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYAXMC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:02:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:34746 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbYAXMC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:02:27 -0500
Date: Thu, 24 Jan 2008 13:02:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tristate choices with mixed tristate and boolean values (v2)
Message-ID: <20080124120236.GA368@uranus.ravnborg.org>
References: <47977D08.76E4.0078.0@novell.com> <20080123171719.GB22967@uranus.ravnborg.org> <47988B1F.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47988B1F.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:57:03AM +0000, Jan Beulich wrote:
> >menu_finalize as it stand today is already too complicated.
> >
> >Could we have this additional functionlity factored out or at least commented
> >so mare humans have a small chance to understand what is going on.
> 
> I'd prefer leaving the factoring-out to Roman, in fear of breaking
> something if I do it myself. I sent out an updated patch just a second
> ago, which adds a comment as you requested and also fixes another
> problem (not one the patch introduced) that utilizing the new
> functionality elsewhere uncovered.

Thanks - I will give Roman a few days and if I see no complains
then I will add it to kbuild.git.

	Sam
