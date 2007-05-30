Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXE3Vvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXE3Vvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760532AbXE3VvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:51:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760756AbXE3VvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:51:08 -0400
Date: Wed, 30 May 2007 17:50:28 -0400
From: Dave Jones <davej@redhat.com>
To: Ben Collins <bcollins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Phil Dibowitz <phil@ipom.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/6] UNUSUAL_DEV: Sync up some reported devices from Ubuntu
Message-ID: <20070530215028.GD2794@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org,
	Phil Dibowitz <phil@ipom.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb-devel@lists.sourceforge.net
References: <98cd38b5.git.bcollins@ubuntu.com> <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 06:39:24PM -0400, Ben Collins wrote:
 > Various unusual dev entries accumulated from Ubuntu bug reports.
 > 
 > CC: Phil Dibowitz <phil@ipom.com>
 > CC: Alan Stern <stern@rowland.harvard.edu>
 > CC: linux-usb-devel@lists.sourceforge.net
 > Signed-off-by: Ben Collins <bcollins@ubuntu.com>
 > ---
 >  drivers/usb/storage/unusual_devs.h |   21 +++++++++++++++++++--
 >  
 > +/* Reported by Edward Chapman <[EMAIL PROTECTED]>

The "<[EMAIL PROTECTED]>" seems a bit pointless.

	Dave

-- 
http://www.codemonkey.org.uk
