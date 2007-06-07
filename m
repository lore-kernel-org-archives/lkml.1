Return-Path: <linux-kernel-owner+w=401wt.eu-S936702AbXFGUvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936702AbXFGUvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbXFGUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:50:56 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54616 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762114AbXFGUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:50:55 -0400
Date: Thu, 7 Jun 2007 13:50:15 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Robert de Rooy <robert.de.rooy@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: ThinkPad T41 - Strange USB 2.0 behaviour
Message-ID: <20070607205015.GD6528@ca-server1.us.oracle.com>
Mail-Followup-To: Robert de Rooy <robert.de.rooy@gmail.com>,
	linux-kernel@vger.kernel.org, greg@kroah.com
References: <46686937.9050306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46686937.9050306@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:23:19PM +0200, Robert de Rooy wrote:
> On my ThinkPad T41 USB 2.0 behaves strange. Most USB 2.0 devices, refuse 
> to function as such. Under Windows I get a message that I should plug 
> the device into a USB 2.0 port (but it continues to function as USB 
> 1.1), while under Linux I need to manually unload ehci-hcd before I can 
> access the device.
> 
> The strange thing is that these USB 2.0 devices used to work just fine, 
> and still do on other machines. In addition I have one USB 2.0 memory 
> key that still works fine (both under Windows and Linux).
> 
> Now to be honest, I think this is a hardware problem, as I have had 
> another T41p before that also suddenly no longer liked USB 2.0 devices, 
> and if you search with Google you find other ThinkPad T41 users 
> complaining about similar behaviour.

	Hardware problem.  You need a new system board.  I had this
problem on my T41, devices would sometimes work, sometimes not
(depending on the reboot).  If I plugged in a USB 1.1 hub, then pluged
the memory reader into the hub, it would always work at 1.1 speeds.
	New system board, USB 2.0 works just fine.

Joel

-- 

Life's Little Instruction Book #274

	"Leave everything a little better than you found it."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
