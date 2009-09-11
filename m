Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZIKFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZIKFNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZIKFNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:13:14 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:51139 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZIKFNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XoqE1Ym8hEbFiQDyJY3rgmXhwQdRcp90tMZvbQPoE9oYe470t9Spi6suLoc9yMx/+D
         fwlcvkkWUAoeOb6Ysvokij1HoJT0KN+gtROuiGUm8UQxjSj50CRce/SENav+0zPPdmfH
         RlH2ZvfJuJ8UzWbzmmZ26aaHkqjYrk/GgBIG0=
Date: Thu, 10 Sep 2009 22:13:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBUNTU: [Upstream] Input: Add keyboard quirk for
	Samsung R59P/R60P/R61P laptops
Message-ID: <20090911051312.GD23210@core.coreip.homeip.net>
References: <1252488035-20118-1-git-send-email-keng-yu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252488035-20118-1-git-send-email-keng-yu.lin@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keng-Yu,

On Wed, Sep 09, 2009 at 05:20:35PM +0800, Keng-Yu Lin wrote:
> OriginalAuthor: Moiseev Vladimir <cdb@linkycat.com>, Alexander Huhlaev <sancheolz@gmail.com>
> BugLink: http://bugs.launchpad.net/bugs/253874
> 
> Add quirk for Samsung R59P/R60P/R61P to make the hotkeys work
> 

I will not be accepting any more patches adding the force-release quirks
to atkbd, in .32 there will be a way to adjust the bitmap through sysfs.

Thanks.

-- 
Dmitry
