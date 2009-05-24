Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZEXTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZEXTG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZEXTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:06:04 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.201.117]:44195 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbZEXTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:06:03 -0400
X-Greylist: delayed 2718 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 15:06:02 EDT
Date: Sun, 24 May 2009 14:20:42 -0400
From: Eric Cooper <ecc@cmu.edu>
To: linux-kernel@vger.kernel.org
Cc: Vlad Cerny <vlad.cerny@gmail.com>
Subject: Network data corruption on atl1e
Message-ID: <20090524182042.GA8159@localhost>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Vlad Cerny <vlad.cerny@gmail.com>
References: <88a913b70905211029j38e22083g407dfba5c17754a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88a913b70905211029j38e22083g407dfba5c17754a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading large files over NFS using the at1le Ethernet driver results
in data corruption in 2.6.29.

Further details are in this thread:
  http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-May/002199.html 

I'll be happy to help with further tests, etc.  Please CC Vlad and me
on any followups, thanks.

-- 
Eric Cooper             e c c @ c m u . e d u
