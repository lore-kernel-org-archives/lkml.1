Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYEPX33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYEPX33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYEPX3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:29:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYEPX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:29:20 -0400
Date: Fri, 16 May 2008 19:29:20 -0400
From: Dave Jones <davej@redhat.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: gianfar build failure.
Message-ID: <20080516232920.GA26131@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
 Since your commit d0313587547092af7f5ee8a576793e1e5d61be89
I see this build failure:

"get_phy_id" [drivers/net/gianfar_driver.ko] undefined!

both CONFIG_PHYLIB and CONFIG_GIANFAR are =m

Missing exports ?

	Dave

-- 
http://www.codemonkey.org.uk
