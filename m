Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbXIJBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbXIJBp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 21:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXIJBpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 21:45:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39800 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXIJBpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 21:45:20 -0400
Date: Mon, 10 Sep 2007 03:46:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unfamiliar notation
Message-ID: <20070910014643.GA22800@uranus.ravnborg.org>
References: <1189386541.7365.50.camel@Tachyon.home> <E1IUXwl-0001Kp-00@calista.eckenfels.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IUXwl-0001Kp-00@calista.eckenfels.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 03:20:15AM +0200, Bernd Eckenfels wrote:
> In article <1189386541.7365.50.camel@Tachyon.home> you wrote:
> > What's the deal with the underscore and the parentheses surrounding the
> > call to menu_get_help?
> 
> it is a macro from gettext, used to translate the string. Usually this
> should only be used on string constants.
Correct.
And only in kconfig since this is the only piece of code supporting gettext in the kernel.

	Sam
