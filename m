Return-Path: <linux-kernel-owner+w=401wt.eu-S1161285AbXBZWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161285AbXBZWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161290AbXBZWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:16:56 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59101 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161285AbXBZWQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:16:56 -0500
X-Sasl-enc: pdq+qyZmm71/z8TkIvFUlzW2KSDOC8/s5IZV7jBmrwBa 1172526426
Date: Mon, 26 Feb 2007 18:46:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling (v2)
Message-ID: <20070226214658.GA26487@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz> <20070226142157.GA2909@khazad-dum.debian.net> <1172501357.5824.91.camel@localhost.localdomain> <20070226152035.GB2909@khazad-dum.debian.net> <20070226161203.GD2909@khazad-dum.debian.net> <1172507907.5824.105.camel@localhost.localdomain> <20070226181202.GH2909@khazad-dum.debian.net> <20070226182604.GJ2909@khazad-dum.debian.net> <Pine.LNX.4.64.0702262217490.10496@twin.jikos.cz> <1172526121.24429.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172526121.24429.15.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Richard Purdie wrote:
> We want to blank (set to 0) if either fb_blank or power isn't set to
> FB_BLANK_UNBLANK. This is the same as setting to brightness if both
> fb_blank and power are set to FB_BLANK_UNBLANK. This is what the above
> expression does.

Is that an ACK, then?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
