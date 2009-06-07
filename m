Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZFGXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZFGXh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZFGXhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:37:46 -0400
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:46213 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZFGXhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:37:45 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jun 2009 19:37:45 EDT
Message-ID: <4A2C47E1.4060606@ph.tum.de>
Date: Mon, 08 Jun 2009 01:06:09 +0200
From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, nbd@openwrt.org, rathamahata@gmail.com,
       ognjen.maric@gmail.com, rjw@sisk.pl, stable@kernel.org
Subject: Re: [PATCH] mac80211: fix minstrel single-rate memory corruption
References: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=12490 on the
> regression list (also http://bugzilla.kernel.org/show_bug.cgi?id=13000).

The patch works well.  No kernel panics anymore.  You made my day!

Thank you,

Thiemo
