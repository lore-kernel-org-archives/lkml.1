Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYHGNtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYHGNtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYHGNtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:49:14 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:61110 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbYHGNtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:49:14 -0400
Date: Thu, 7 Aug 2008 10:32:47 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       Sylver Bruneau <sylver.bruneau@googlemail.com>, buytenh@wantstofly.org
Subject: Re: [WATCHDOG] v2.6.27-rc patches
Message-ID: <20080807093247.GH8301@fluff.org.uk>
References: <20080806202918.GA29386@infomag.infomag.iguana.be> <20080807070342.GB2504@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807070342.GB2504@deprecation.cyrius.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 10:03:42AM +0300, Martin Michlmayr wrote:
> * Wim Van Sebroeck <wim@iguana.be> [2008-08-06 22:29]:
> > Please pull from 'master' branch of
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> > or if master.kernel.org hasn't synced up yet:
> > 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> > 
> > This will update the following files:
> 
> Wim, is there any reason why the new Orion driver is not included in
> this pull request?  Or was the driver not submitted to you?

These look like fixes and cleanups, so new drivers shouldn't have been
included in here.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
