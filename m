Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYHILuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYHILuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 07:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYHILt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 07:49:57 -0400
Received: from lazybastard.de ([212.112.238.170]:50778 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYHILt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 07:49:56 -0400
X-Greylist: delayed 1974 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 07:49:56 EDT
Date: Sat, 9 Aug 2008 13:20:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm] logfs: fix printk format warnings
Message-ID: <20080809112014.GC30358@logfs.org>
References: <20080808210318.GA5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080808210318.GA5093@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 August 2008 01:03:18 +0400, Alexander Beregalov wrote:
> 
> LogFS: Fix printk format warnings

Excellent, thanks.

[ I really wish gcc would one day learn some format string length
modifier for fixed-size types. ]

Jörn

-- 
If a problem has a hardware solution, and a software solution,
do it in software.
-- Arnd Bergmann
