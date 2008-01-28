Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYA1NnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYA1NnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYA1NnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:43:04 -0500
Received: from eazy.amigager.de ([213.239.192.238]:54687 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYA1NnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:43:03 -0500
Date: Mon, 28 Jan 2008 14:43:05 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
Message-ID: <20080128134305.GA31052@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080128002934.GA6354@dose.home.local> <18333.37002.749771.524523@harpo.it.uu.se> <20080128125535.GE32496@elte.hu> <18333.55970.74841.660462@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18333.55970.74841.660462@harpo.it.uu.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 14:37:38 +0100, Mikael Pettersson wrote:

[...]

> However, it _is_ a fact that there is a proliferation of specialized
> mailing lists, and it is also a fact that many developers _only_ read
> those lists. I'm in no way defending this behaviour, on the contrary
> I probably dislike it as much as you do. But we can't ignore it.

I planned to post this to netdev first, but then I thought that it's
more a task for the stable team and/or those people who track
regressions, and I don't know if those people track all the subsystem
mailing lists. Especially as there is a patch that fixes the issue for
me, and the corresponding bugzilla entry is alrealy marked as resolved
and "patch available", so it seems to me as it is just a matter of
incorporating an existing patch into further revisions of 2.6.24.

Regards,
Tino
