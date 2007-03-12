Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXCLGAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXCLGAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965143AbXCLGAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:00:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:5662 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965148AbXCLGAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jfuN1rKapTCjxg8cL+Xe6jqRVtReNMaie/5TtN/27Zq4Z4Hld3wzeJBF9/Ojmlu33OEbkxcNAUBWLRKMssvVgHAum6PQx0U5MBeVXn6ApsjIW8VEwNUmE86a6e6rvC8213/tl8X2f9och8zGW7DbN2eZE+112d9IJjLaJmFEYtk=
Message-ID: <aa79d98a0703112300w3de83f20n5b520c0ab7689669@mail.gmail.com>
Date: Mon, 12 Mar 2007 09:00:07 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070311195033.GA3302@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070310160614.GB10230@cvg> <20070310194617.2aef1006@localhost>
	 <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr>
	 <20070310175058.GA19878@cvg>
	 <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr>
	 <20070310212730.GA2577@uranus.ravnborg.org>
	 <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr>
	 <20070310224534.GA3150@uranus.ravnborg.org>
	 <20070311100723.GA10359@cvg>
	 <20070311195033.GA3302@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Sam Ravnborg <sam@ravnborg.org> wrote:
[..snip..]
| > To make the conversion we should consider renaming from
| > current "Load alternate" to "Open config file..."
| > and likewise "Save alternate" to "Save config file as..."
| >
| > Comments?
| >
| >        Sam
[..snip...]

I think that is excellent. (Actually I can't test it now but the idea
is just perfect)
