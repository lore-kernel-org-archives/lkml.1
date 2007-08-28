Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbXH1Kmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbXH1Kmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbXH1Km3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:42:29 -0400
Received: from nn7.de ([85.214.94.156]:47135 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXH1Km2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:42:28 -0400
Subject: Re: Linux 2.6.23-rc4
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200708281233.11971.rjw@sisk.pl>
References: <alpine.LFD.0.999.0708271847560.25853@woody.linux-foundation.org>
	 <1188295796.4594.2.camel@localhost>  <200708281233.11971.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 10:42:20 +0000
Message-Id: <1188297740.4594.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 12:33 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 28 August 2007 12:09, Soeren Sonnenburg wrote:
[...]
> > I hope I find time to do a bisect soon...
> 
> Is this a regression from 2.6.23-rc3, or from an earlier kernel?

it is a regression from rc3, all kernels I tested up to 23-rc3 (plus
some unknown git revision) were working ok.

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
