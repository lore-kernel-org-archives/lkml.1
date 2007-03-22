Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbXCVXWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbXCVXWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCVXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:22:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46285 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbXCVXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:22:09 -0400
Date: Thu, 22 Mar 2007 16:22:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Confused about audio drivers - where do I start?
Message-Id: <20070322162241.bdef76ac.randy.dunlap@oracle.com>
In-Reply-To: <46030AAD.4030509@freescale.com>
References: <46030AAD.4030509@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 18:01:01 -0500 Timur Tabi wrote:

> If I were to write a non-USB audio device driver from scratch (for new hardware), what 
> interface would I use?  Has ALSA become the official Linux kernel audio subsystem?  Is 

Yes.

> there a specific device driver I should use as a sample?

Dunno.  But ALSA has docs.  See
http://www.alsa-project.org/documentation.php#0.9doc

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
