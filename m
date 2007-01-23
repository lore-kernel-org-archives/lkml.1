Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbXAWEyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbXAWEyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbXAWEyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:54:00 -0500
Received: from twinlark.arctic.org ([207.29.250.54]:57829 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbXAWEx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:53:59 -0500
Date: Mon, 22 Jan 2007 20:53:59 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andi Kleen <ak@muc.de>
cc: vojtech@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [patch] faster vgetcpu using sidt (take 2)
In-Reply-To: <20070118214521.GA14022@muc.de>
Message-ID: <Pine.LNX.4.64.0701222047050.11520@twinlark.arctic.org>
References: <Pine.LNX.4.64.0701061807530.26307@twinlark.arctic.org>
 <Pine.LNX.4.64.0701132245260.27121@twinlark.arctic.org>
 <Pine.LNX.4.64.0701140002330.16472@twinlark.arctic.org> <20070118214521.GA14022@muc.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jan 2007, Andi Kleen wrote:

> > let me know what you think... thanks.
> 
> It's ok, although I would like to have the file in a separate directory.

cool -- do you have a directory in mind?

and would you like this change as two separate patches or one combined 
patch?

thanks
-dean
