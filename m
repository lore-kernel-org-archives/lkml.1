Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbZE3OlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbZE3OlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZE3OlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:41:12 -0400
Received: from main.gmane.org ([80.91.229.2]:56325 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZE3OlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:41:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: unbreak suspend on zaurus on 2.6.30-rc6
Date: Sat, 30 May 2009 14:41:00 +0000 (UTC)
Message-ID: <gvrghs$6oa$1@ger.gmane.org>
References: <20090529105619.GA24187@elf.ucw.cz>
	<1243632629.9207.5.camel@utx.utx.cz> <20090530095550.GA19058@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> On Fri 2009-05-29 23:30:29, Stanislav Brabec wrote:
>> Pavel Machek wrote:
>> 
>> > This is hacky patch to unbreak suspend on -rc6; perhaps it will be
>> > useful to someone.
>> 
>> Thanks for the patch. I tried rc7 yesterday with same problem.
>> 
>> Your patch makes resume working again. Serial console does not work
>> after resume, inserting or removing charger causes resume, and syslog
>> is a bit noisy now.
> 
> Plus I guess I should mention that my patch disables offline charging.
> So be sure to shutdown for charger...
> 									Pavel

Or charge online? IIRC Zaurii don't have any problems with online charging,
do they?

-- 
With best wishes
Dmitry


