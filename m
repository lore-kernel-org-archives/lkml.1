Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbXBEGpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbXBEGpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXBEGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:45:05 -0500
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:42394 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752747AbXBEGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:45:04 -0500
X-Greylist: delayed 2541 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 01:45:04 EST
Subject: Re: Intel chooses not to support its HECI/QPS Chip in Linux?
From: Arjan van de Ven <arjan@linux.intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702041050170.14035@p34.internal.lan>
References: <Pine.LNX.4.64.0702041050170.14035@p34.internal.lan>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Feb 2007 07:02:14 +0100
Message-Id: <1170655334.3073.1227.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 10:57 -0500, Justin Piszcz wrote:
> Hi,
> 
> Anyone from Intel that reads LKML, could you provide an update as to what 
> is happening with support for your HECI Controller/QPS chip, which is used 
> on 965 (and possibly other?) chipsets.

I asked the right folks and the word I got was "Soon". The code we have
needs some major cleanups before it's suitable for lkml posting... but
it'll be there soon. We're working on the cleanups full time.... We'll
send an update when we're further along
