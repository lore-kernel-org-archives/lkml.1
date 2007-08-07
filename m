Return-Path: <linux-kernel-owner+w=401wt.eu-S965389AbXHGWO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389AbXHGWO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937909AbXHGWNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:13:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937795AbXHGWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:12:59 -0400
Date: Tue, 7 Aug 2007 18:12:54 -0400
From: Dave Jones <davej@redhat.com>
To: Maes Rich <rmaes@spraycool.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make menuconfig refuses to let CONFIG_X86_64=y and
	CONFIG_64BIT remain
Message-ID: <20070807221254.GA13466@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Maes Rich <rmaes@spraycool.com>, linux-kernel@vger.kernel.org
References: <72E9FC6E46135E4183E5211D555A2200C32746@ds10965.spraycool.com> <72E9FC6E46135E4183E5211D555A2200C32749@ds10965.spraycool.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72E9FC6E46135E4183E5211D555A2200C32749@ds10965.spraycool.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 02:18:16PM -0700, Maes Rich wrote:
 > I have a little more information.  I tried generating the configuration
 > using a 'make ARCH=x86_64 defconfig' I took the resulting file, which is
 > configured for x86_64 and use it as a alternative configuration file for
 > makeconfig and then save it without making any changes.  The newly saved
 > file has been restructured for 32bit.  Does this sound like a bug?

did you set ARCH=x86_64 in the make menuconfig command too ?

	Dave

-- 
http://www.codemonkey.org.uk
