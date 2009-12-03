Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZLCMDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZLCMDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLCMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:03:22 -0500
Received: from poutre.nerim.net ([62.4.16.124]:62169 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZLCMDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:03:21 -0500
Date: Thu, 3 Dec 2009 13:03:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091203130325.610d5c47@hyperion.delvare>
In-Reply-To: <1259835846.5316.782.camel@thor.local>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	<1259744042.8188.397.camel@thor.local>
	<20091202101055.1ae7bf35@hyperion.delvare>
	<1259835846.5316.782.camel@thor.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009 11:24:06 +0100, Michel Dänzer wrote:
> On Wed, 2009-12-02 at 10:10 +0100, Jean Delvare wrote: 
> > BTW, I also have i2c-powermac patches queued for 2.6.33 if you want to
> > give them a try:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-powermac-*.patch
> > 
> > (Don't look for patch 5/6, it was broken so I discarded it.)
> 
> My PowerBook5,8 boots and works fine with all of these applied and
> CONFIG_I2C_POWERMAC=y, so for all of them:
> 
> Tested-by: Michel Dänzer <michel@daenzer.net>

Very nice, thank you!

-- 
Jean Delvare
