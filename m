Return-Path: <linux-kernel-owner+w=401wt.eu-S1764672AbYETL1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764672AbYETL1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759334AbYETL1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:27:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:46223 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbYETL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:27:39 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Tue, 20 May 2008 13:27:34 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <200805201258.00376.oliver@neukum.org> <20080520111700.GE5025@ics.muni.cz>
In-Reply-To: <20080520111700.GE5025@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201327.34678.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 20 Mai 2008 13:17:01 schrieb Lukas Hejtmanek:
> On Tue, May 20, 2008 at 12:57:59PM +0200, Oliver Neukum wrote:
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > 
> > Can you please also post your .config with which this problem happens?
> 
> done.
> http://bugzilla.kernel.org/show_bug.cgi?id=10630

Aha. Thanks.
Please recompile without CONFIG_USB_SUSPEND

	Regards
		Oliver
