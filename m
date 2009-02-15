Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZBOP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZBOP2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZBOP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:28:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45042 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZBOP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:28:29 -0500
Date: Sun, 15 Feb 2009 15:28:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Shem Multinymous <multinymous@gmail.com>, Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Frank Seidel <frank@f-seidel.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215152822.GA22529@srcf.ucam.org>
References: <499569A9.5030202@suse.de> <41840b750902141632l5c4bd705m1b528900466a25fd@mail.gmail.com> <20090215102707.174e770f@hyperion.delvare> <20090215134115.GA21670@srcf.ucam.org> <20090215162359.763b3918@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215162359.763b3918@hyperion.delvare>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 04:23:59PM +0100, Jean Delvare wrote:
> On Sun, 15 Feb 2009 13:41:15 +0000, Matthew Garrett wrote:
> > You're arguing that sysfs interfaces are copyrightable?
> 
> I'm not arguing anything. I'll let you, Shame Multithing and anyone
> else with too much spare time argue whatever you want. Me, I have many
> more useful things to do.

Adopting an interface that's already in use in the wild is a perfectly 
reasonable thing to do. The argument is over whether the tp_smapi driver 
itself has IP issues, not over whether its sysfs interface does.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
