Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYFLVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYFLVhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYFLVgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:36:55 -0400
Received: from mail201.messagelabs.com ([216.82.254.211]:5907 "EHLO
	mail201.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYFLVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:36:54 -0400
X-VirusChecked: Checked
X-Env-Sender: mhanafi@csc.com
X-Msg-Ref: server-11.tower-201.messagelabs.com!1213306601!7459179!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [20.137.2.87]
To: linux-kernel@vger.kernel.org
Subject: 
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OF16371842.1DB9C597-ON85257466.0076B0CF-85257466.0076BBB4@csc.com>
From: Mahmoud Hanafi <mhanafi@csc.com>
Date: Thu, 12 Jun 2008 17:36:49 -0400
X-MIMETrack: Serialize by Router on AMER-GW09/SRV/CSC(Release 8.0.1|February 07, 2008) at
 06/12/2008 05:39:45 PM,
	Serialize complete at 06/12/2008 05:39:45 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have random nodes experience killing of most daemons( syslog, ssh, 
cron, etc). All these daemons report getting a sigkill or sigterm.

My question.... Is there a way to log all signals and the originator 
pid/proc name.

-Mahmoud


