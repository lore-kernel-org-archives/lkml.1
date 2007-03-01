Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXCAAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXCAAH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXCAAH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:07:28 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41019
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbXCAAH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:07:28 -0500
From: Rob Landley <rob@landley.net>
To: "Gregor Jasny" <gjasny@googlemail.com>
Subject: Re: Menuconfig has butterfly effects?
Date: Wed, 28 Feb 2007 19:07:04 -0500
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200702271812.42616.rob@landley.net> <9d2cd630702271543i1e7931f8kd786570d2ff60adf@mail.gmail.com>
In-Reply-To: <9d2cd630702271543i1e7931f8kd786570d2ff60adf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281907.06152.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 February 2007 6:43 pm, Gregor Jasny wrote:
> Hi,
> 
> 2007/2/28, Rob Landley <rob@landley.net>:
> > I ran "make ARCH=x86_64 menuconfig", did a lot of editing, and saved
> > the .config.  Then I copied that to a backup, ran "make oldconfig" on the
> 
> I'd try with "make ARCH=x86_64 oldconfig"

I did.  Sorry for the confusion there.  (If I'd gotten that wrong, there'd 
have been a bit more change. :)

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
