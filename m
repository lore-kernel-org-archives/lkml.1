Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbXEXUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbXEXUIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXEXUID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:08:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbXEXUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:07:59 -0400
Date: Thu, 24 May 2007 16:07:54 -0400
From: Dave Jones <davej@redhat.com>
To: Amaury De Ganseman <amaury.deganseman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.2 and vfat
Message-ID: <20070524200754.GB29049@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Amaury De Ganseman <amaury.deganseman@gmail.com>,
	linux-kernel@vger.kernel.org
References: <7fddb68d0705240053n54a96606u238a37e3a265b23c@mail.gmail.com> <20070524165307.GB23169@redhat.com> <7fddb68d0705241256n11843438o1b8e2fc5c2ee3c99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fddb68d0705241256n11843438o1b8e2fc5c2ee3c99@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 09:56:04PM +0200, Amaury De Ganseman wrote:
 > It's the same with sdc1

exactly the same error ? (the dmesg only listed the sdc errors)
what does fdisk -l /dev/sdc look like ?
does fsck.vfat /dev/sda1 find any errors?

	Dave

-- 
http://www.codemonkey.org.uk
