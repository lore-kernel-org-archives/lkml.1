Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZBEP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZBEP2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZBEP1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:27:53 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:50613 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203AbZBEP1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:27:52 -0500
Date: Thu, 5 Feb 2009 10:27:51 -0500
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: Fix support for console port other than ttyS0 on mcf.c
Message-ID: <20090205152751.GL26064@csclub.uwaterloo.ca>
References: <20090204201518.GH26064@csclub.uwaterloo.ca> <20090204202009.GI26064@csclub.uwaterloo.ca> <Pine.LNX.4.64.0902042200340.25136@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902042200340.25136@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 10:00:58PM +0100, Geert Uytterhoeven wrote:
> On Wed, 4 Feb 2009, Lennart Sorensen wrote:
> > Perhaps CCing linux-m68k@lists.linux-m68k.org would be a good idea.
> 
> Thanks, but this is a uClinux driver.

This is a patch against Linus's current tree.  How is that a uClinux
driver?  I am using a build of yesterday's git tree from Linus on a
5271evb board and this fixes the console port with it.  I have no user
space yet, so whatever does uClinux have to do with anything?

-- 
Len Sorensen
