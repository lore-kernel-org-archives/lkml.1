Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318Ab0ASThx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0ASThx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050Ab0ASThw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:37:52 -0500
Received: from eazy.amigager.de ([213.239.192.238]:52118 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0ASThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:37:51 -0500
Date: Tue, 19 Jan 2010 20:37:45 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with
 2.6.33-rc4-git2
Message-ID: <20100119193745.GA5797@x61.home>
Mail-Followup-To: Stephen Hemminger <shemminger@vyatta.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100115091053.GA5477@mac.home>
 <201001180136.45823.rjw@sisk.pl>
 <20100118083757.GA2619@mac.home>
 <201001182234.55113.rjw@sisk.pl>
 <20100118144340.100c9544@nehalam>
 <20100119103248.GA8527@mac.home>
 <20100119105105.184c3f01@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119105105.184c3f01@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 10:51:05 -0800, Stephen Hemminger wrote:
> Is this better worse or the same? It make sure that some
> registers are set on resume that might matter.

I see not difference.

Regards,
Tino
