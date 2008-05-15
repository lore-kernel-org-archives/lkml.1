Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbYEOQKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbYEOQKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYEOQKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:10:12 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:45903 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbYEOQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:10:11 -0400
Date: Thu, 15 May 2008 18:05:26 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: 2.6.26-rc1 sound regression
Message-ID: <20080515160525.GA2708@erig.dyndns.org>
Mail-Followup-To: Rene Herman <rene.herman@keyaccess.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Glauber Costa <gcosta@redhat.com>
References: <20080514130742.GA28872@erig.dyndns.org> <482B4E4A.3000700@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482B4E4A.3000700@keyaccess.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:40:42PM +0200, Rene Herman wrote:
> On 14-05-08 15:07, Wolfgang Erig wrote:
>
>> my sound stops working with 2.6.26-rc1,
>
> Thanks for the report and investigation -- this bug has been fixed in  
> current mainline (a little post -rc2) already though.
>
> It's commit 4a367f3a9dbf2e7ffcee4702203479809236ee6e, "x86/PCI: fix  
> broken ISA DMA"

tried the latest version
(git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
and it works.

Thanks,
Wolfgang (happy to hear nice music again)
