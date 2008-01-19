Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYASTxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYASTxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYASTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:53:16 -0500
Received: from main.gmane.org ([80.91.229.2]:60394 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYASTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:53:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Date: Sat, 19 Jan 2008 19:53:00 +0000 (UTC)
Message-ID: <fmtker$mv1$1@ger.gmane.org>
References: <20080118162627.GA28974@rakim.wolfsonmicro.main>
	<1200673631-366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20080118120148.ZZRA012@mailhub.coreip.homeip.net>
	<fmqq50$te0$1@ger.gmane.org> <20080118215715.GB27399@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip-83-149-3-186.nwgsm.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:

> On Fri, Jan 18, 2008 at 06:11:45PM +0000, Dmitry Baryshkov wrote:
>> Hi,
>> 
>> Dmitry Torokhov wrote:
>> 
>> > I will need some more time to review and understand the need for the
>> > new bus in the driver.
>> 
>> Most likely this can be converted to platform_bus. Maybe this can also
>> get help from soon-to-be posted MFD (multi function devices) helpers.
> 
> Is there any current discussion of these in public? I'm interested
> mainly due to my involvement in the SM501 core and FB driver. Can I also
> request to be Cc'd when these are posted?


You can find the current work at
git://git.mnementh.co.uk/linux-2.6-im.git#tmio_dev_try3. Look for "Core MFD support" changeset.
For CC concact Ian <spyro@f2s.com>.

> 
> --
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'





-- 
With best wishes
Dmitry


