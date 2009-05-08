Return-Path: <linux-kernel-owner+w=401wt.eu-S1764008AbZEHVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764008AbZEHVDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbZEHVDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:03:06 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:33436 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZEHVDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:03:05 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 17:03:04 EDT
Date: Sat, 9 May 2009 00:53:42 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH] w1-gpio: add external pull-up enable callback
Message-ID: <20090508205342.GA25919@2ka.mipt.ru>
References: <1241527413-22920-1-git-send-email-daniel@caiaq.de> <20090508201302.GA24080@buzzloop.caiaq.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508201302.GA24080@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.

On Fri, May 08, 2009 at 10:13:02PM +0200, Daniel Mack (daniel@caiaq.de) wrote:
> (cc Evgeniy Polyakov)
> 
> Evgeniy, could you give some feedback on this? Ville Syrjala gave his
> Acked-by already.

Looks good! Feel free to add mine too and submit through Andrew Morton
or via other path.

-- 
	Evgeniy Polyakov
