Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYDOWsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYDOWsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759731AbYDOWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:48:13 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:40211 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbYDOWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:48:12 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>
	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>
	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>
	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>
	<48052BB3.2090509@gmail.com>
Date: Wed, 16 Apr 2008 10:43:18 +1200
In-Reply-To: <48052BB3.2090509@gmail.com> (Tejun Heo's message of "Wed, 16 Apr
	2008 07:26:59 +0900")
Message-ID: <87od8awxh5.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Paul Collins wrote:
>> I found a setting labelled "SATA Power Management".  It was set to
>> "Enable".  When I set it to "Disable", 2.6.25-rc9 detected the optical
>> drive.
>
> This can't be something changed between 2.6.24 and 2.6.25-rc9.  Can
> you please double check that?

I double-checked as follows:

* Verified "SATA Power Management" set to "Enable"
* Verified optical device present in 2.6.24.3
* Verified optical device not present in 2.6.25-rc9

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
