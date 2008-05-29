Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYE2VQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYE2VQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYE2VQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:16:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbYE2VQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:16:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Thu, 29 May 2008 23:17:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.LYF.TgIOIB@albercik> <200805251153.26882.oliver@neukum.org>
In-Reply-To: <200805251153.26882.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292317.15117.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of May 2008, Oliver Neukum wrote:
> Am Samstag 24 Mai 2008 22:31:39 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> Alan's patch fixes the issue. It has been tested and submitted.

Has it reached the Linus' tree already?

Rafael
