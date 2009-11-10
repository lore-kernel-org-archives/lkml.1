Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZKJMlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZKJMlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZKJMlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:41:14 -0500
Received: from smtp.nokia.com ([192.100.105.134]:37721 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZKJMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:41:12 -0500
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 14:40:48 +0200
Message-Id: <1257856848.21596.753.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Nov 2009 12:40:53.0484 (UTC) FILETIME=[0A8BD2C0:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomi,

could you please kindly ask Stephen (CCed) to include the DSS2 tree into
linux-next, because you are going to merge it the next merge window, and
there does not seem to be any blocker for this.

Being in linux-next for a while is really important.

On Mon, 2009-11-09 at 13:45 +0200, Tomi Valkeinen wrote:
> This patch set implement new display subsystem driver (DSS2) and omapfb driver
> for OMAP2/3. The patches have been reviewed on linux-omap and linux-fbdev-devel
> mailing lists. The patches can also be found from master branch in
> http://gitorious.org/linux-omap-dss2/linux. The branch is based on the
> linux-next tree.
> 
> The patches include DSS documentation patch that includes more instructions for
> module parameters, sysfs files etc.
> 
> The patches enable DSS2 for OMAP3430 SDP board and support for other boards can
> be sent after the DSS2 has been merged. DSS2 is used in various boards, for
> example Nokia N900, Beagle Board and Overo.
> 
> I don't currently have any OMAP2 board to test DSS2, but it has worked on OMAP2
> and the possible fixes needed should be minimal.
> 
> OMAP1 is not supported, and so the old DSS needs to be used on OMAP1 boards. My
> longer term plan is to move all OMAP2 stuff from the old DSS to the new one,
> and then shrink the old DSS to support OMAP1 only.
> 
> DSS2 is partly based on the old omapfb driver by Imre Deak, and Imre has also
> contributed to DSS2 quite a bit. Ville Syrjälä has been contributing to scaling
> and tv-out work, and Topi Pohjolainen to VRFB. Also some contributions have
> been made by Hardik Shah, Vaibhav Hiremath, and perhaps some others that I have
> forgotten =).

Tomi,

could you please kindly ask Stephen (CCed) to include the DSS2 tree into
linux-next, because you are going to merge it the next merge window, and
there does not seem to be any blocker for this.

Being in linux-next for a while is really important.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

