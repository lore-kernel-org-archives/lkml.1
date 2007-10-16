Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXJPKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXJPKjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbXJPKjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:39:43 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:12372 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbXJPKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:39:40 -0400
Date: Tue, 16 Oct 2007 06:35:13 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH v3] hwmon: Add power meter spec  to Documentation/hwmon/sysfs-interface
Message-ID: <20071016103513.GB3731@jupiter.solarsys.private>
References: <20071009203923.GJ16752@tree.beaverton.ibm.com> <20071015171029.39ab3fe6@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015171029.39ab3fe6@hyperion.delvare>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

> On Tue, 9 Oct 2007 13:39:24 -0700, Darrick J. Wong wrote:
> > Update the hwmon sysfs interface documentation to include a specification
> > for power meters.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> >  Documentation/hwmon/sysfs-interface |   31 +++++++++++++++++++++++++++++++
> >  1 files changed, 31 insertions(+), 0 deletions(-)

* Jean Delvare <khali@linux-fr.org> [2007-10-15 17:10:29 +0200]:
> Looks good, thanks for your patience :)
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

