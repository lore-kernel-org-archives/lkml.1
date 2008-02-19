Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYBSRCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYBSRCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYBSRBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:01:54 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:56416 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYBSRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:01:53 -0500
Date: Tue, 19 Feb 2008 17:01:47 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Aurelien Jarno <aurelien@aurel32.net>, Adrian Bunk <bunk@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [MIPS] BCM47XX: use new SSB SPROM data structure
Message-ID: <20080219170147.GA15678@linux-mips.org>
References: <20080217200947.GH1403@cs181133002.pp.htv.fi> <20080218074944.GA9317@hall.aurel32.net> <20080218100126.GA22519@hall.aurel32.net> <20080218100431.GC22519@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218100431.GC22519@hall.aurel32.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 11:04:31AM +0100, Aurelien Jarno wrote:

> Switch the BCM47XX code to the new SPROM data structure now that
> the old one has been removed.

Thanks, applied too.

  Ralf
