Return-Path: <linux-kernel-owner+w=401wt.eu-S1751253AbXBZPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbXBZPkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXBZPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:40:00 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:52242 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751253AbXBZPj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:39:59 -0500
Date: Mon, 26 Feb 2007 16:39:57 +0100
From: Erik Mouw <erik@harddisk-recovery.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Changelog question
Message-ID: <20070226153956.GA27210@harddisk-recovery.com>
References: <Pine.LNX.4.60.0702242012340.2789@rtl14.hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0702242012340.2789@rtl14.hofr.at>
Organization: Harddisk-recovery.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 08:29:02PM +0100, Nicholas Mc Guire wrote:
> looking at the Changelogs of the last 2.6.17 kernel and the
> first 2.6.18 it is obvious that a lot happened in between - are 
> there some changelogs related to 2.6.18 development that are not found
> at http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.18.# + 
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.18-rc#
> For assessment purposes it would be helpfull to know what low level 
> changes happened i.e. when and where were __raw_spin_* introduced ? but
> I was not able to extract such infos from the ChangeLogs in the above
> directories.

Use git to figure out:

  git-log v2.6.17..v2.6.18


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.nl -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
