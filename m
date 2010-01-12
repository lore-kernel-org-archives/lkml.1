Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302Ab0ALHUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0ALHUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445Ab0ALHUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:20:05 -0500
Received: from lazybastard.de ([212.112.238.170]:32869 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab0ALHUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:20:05 -0500
Date: Tue, 12 Jan 2010 08:19:32 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
Message-ID: <20100112071931.GA18822@logfs.org>
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100111140255.GA1416@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 January 2010 15:05:42 +0100, Pavel Machek wrote:
> 
> Flash has special mapping layer, and does not care (SD/MMC), or is a
> raw nand and can't be used as block device (smartmedia).

Complete bullsh*t.  Smartmedia can (and arguably must) be used as a
block device and all devices you listed do care about alignment.

Jörn

-- 
Consensus is no proof!
-- John Naisbitt
