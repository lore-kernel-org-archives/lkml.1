Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYFLVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYFLVhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYFLVhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:37:45 -0400
Received: from mail87.messagelabs.com ([216.82.250.19]:39838 "EHLO
	mail87.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYFLVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:37:44 -0400
X-VirusChecked: Checked
X-Env-Sender: mhanafi@csc.com
X-Msg-Ref: server-14.tower-87.messagelabs.com!1213306663!1270193!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [20.137.2.88]
To: linux-kernel@vger.kernel.org
Subject: Tracking all signals how to
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OF63113826.C91E01A9-ON85257466.0076BE5C-85257466.0076CEB5@csc.com>
From: Mahmoud Hanafi <mhanafi@csc.com>
Date: Thu, 12 Jun 2008 17:37:38 -0400
X-MIMETrack: Serialize by Router on AMER-GW09/SRV/CSC(Release 8.0.1|February 07, 2008) at
 06/12/2008 05:40:35 PM,
	Serialize complete at 06/12/2008 05:40:35 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have random nodes experience killing of most daemons( syslog, ssh, 
cron, etc). All these daemons report getting a sigkill or sigterm.

My question.... Is there a way to log all signals and the originator 
pid/proc name.

Thanks,
Mahmoud
