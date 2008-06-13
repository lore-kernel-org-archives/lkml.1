Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYFMPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYFMPne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbYFMPnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:43:23 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62334 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756486AbYFMPnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:43:22 -0400
Date: Fri, 13 Jun 2008 16:42:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: webmaster@dragonslave.de
cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: linux-next Regression: Unable to locate IOAPIC
In-Reply-To: <200806131307.39807.dex@dragonslave.de>
Message-ID: <Pine.LNX.4.55.0806131638320.29380@cliff.in.clinika.pl>
References: <200806051100.12885.dex@dragonslave.de> <200806102229.10512.dex@dragonslave.de>
 <4851AA24.7060906@gmail.com> <200806131307.39807.dex@dragonslave.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008, Daniel Exner wrote:

> I attached dmesg and config , both from working 2.6.26-rc5 with git-acpi patch 
> below and from linux-next snapshot 20080604.

 Unfortunately dmesg.rc5.acpi is missing important information at the
beginning -- please retry with a larger buffer (LOG_BUF_SHIFT).

  Maciej
