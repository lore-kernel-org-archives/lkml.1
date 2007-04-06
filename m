Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXDFNjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXDFNjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXDFNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:39:44 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:3682 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079AbXDFNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:39:43 -0400
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: Alan Hourihane <alanh@fairlite.demon.co.uk>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175818158.31131.63.camel@daplas>
References: <1175769886.10382.29.camel@localhost>
	 <1175818158.31131.63.camel@daplas>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 14:39:37 +0100
Message-Id: <1175866777.10112.5.camel@jetpack.demon.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 08:09 +0800, Antonino A. Daplas wrote:
> On Thu, 2007-04-05 at 11:44 +0100, Alan Hourihane wrote:
> > Attached is a patch against 2.6.21-rc5 which adds the Intel Vermilion
> > Range support.
> > 
> > Intel funded Tungsten Graphics to do this work.
> > 
> > If there's any problems or updates needed to be done to get accepted,
> > please let me know.
> > 
> 
> Preferably, add sparse annotations and compile with make C=1. I've
> included possible sparse annotations (the only ones I can see) below.

Great. Thanks for this information.

> Perhaps backling_on/off and panel_on/off can be moved to the backlight
> subsystem?

Another good pointer.

Thanks. I'll revisit things and get back to the list.

Alan.

