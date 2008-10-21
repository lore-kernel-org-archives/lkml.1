Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYJUJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYJUJ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJUJ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:57:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4904 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYJUJ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:57:33 -0400
Date: Tue, 21 Oct 2008 10:57:32 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add support for the WM8350 watchdog
Message-ID: <20081021095728.GH10841@sirena.org.uk>
References: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224529931-9860-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Use the Force, Luke.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 08:12:11PM +0100, Mark Brown wrote:

> +	if (!wm8350) {
> +		printk(KERN_CRIT "FNORD\n");

Gah, obviously this printk() shouldn't be there - I'll submit an updated
version once you've had time to review this.  Sorry about that.
