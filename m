Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbYEYJxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbYEYJxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYEYJxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:53:31 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33890 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbYEYJxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:53:30 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Sun, 25 May 2008 11:53:26 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.LYF.TgIOIB@albercik>
In-Reply-To: <TW_YzGo9TFP.A.LYF.TgIOIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251153.26882.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 24 Mai 2008 22:31:39 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

Alan's patch fixes the issue. It has been tested and submitted.

	Regards
		Oliver
