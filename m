Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXEXQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXEXQyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXEXQyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:54:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXEXQyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:54:10 -0400
Date: Thu, 24 May 2007 12:53:07 -0400
From: Dave Jones <davej@redhat.com>
To: Amaury De Ganseman <amaury.deganseman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.2 and vfat
Message-ID: <20070524165307.GB23169@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Amaury De Ganseman <amaury.deganseman@gmail.com>,
	linux-kernel@vger.kernel.org
References: <7fddb68d0705240053n54a96606u238a37e3a265b23c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fddb68d0705240053n54a96606u238a37e3a265b23c@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 09:53:31AM +0200, Amaury De Ganseman wrote:
 > Hi,
 > 
 > Since 2.6.21 I can't mount my usb key (vfat).
 > I don't know if it's related to the vfat patch in 2.6.21.2....
 > 
 > Here is the dmesg error parts:
 > 
 > FAT: invalid media value (0xb9)
 > VFS: Can't find a valid FAT filesystem on dev sdc.

Is it definitly on sdc ? Unless you reformatted it, chances
are you want to be mounting sdc1

	Dave

-- 
http://www.codemonkey.org.uk
