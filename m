Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbYFZTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbYFZTXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYFZTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:23:21 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:43399 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYFZTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:23:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=One+8mjhzF/9SR13lKTNyxj9tMrpUKotYKU03y87rWrEOfjoUpJg4hjmvpAhrk2jg
	B4xF6p2Q3p+dXxKMaRuxHt0zB3kLzesk4jFQ6LxPXCPaY0eCyxqdAqr69TnlV5Atdep
	UnEQydeH6HQA/MsrCicNp3qrCvCd06Y/ThKz9u0=
Message-ID: <4863ECCE.2000407@seznam.cz>
Date: Thu, 26 Jun 2008 21:23:58 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com
Subject: Re: [PATCH 30/60] microblaze_v4: support for a.out
References: <1214483429-32360-22-git-send-email-monstr@seznam.cz> <1214483429-32360-23-git-send-email-monstr@seznam.cz> <1214483429-32360-24-git-send-email-monstr@seznam.cz> <1214483429-32360-25-git-send-email-monstr@seznam.cz> <1214483429-32360-26-git-send-email-monstr@seznam.cz> <1214483429-32360-27-git-send-email-monstr@seznam.cz> <1214483429-32360-28-git-send-email-monstr@seznam.cz> <1214483429-32360-29-git-send-email-monstr@seznam.cz> <1214483429-32360-30-git-send-email-monstr@seznam.cz> <1214483429-32360-31-git-send-email-monstr@seznam.cz> <20080626143713.GE30954@cs181140183.pp.htv.fi>
In-Reply-To: <20080626143713.GE30954@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm2<174357076>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jun 26, 2008 at 02:29:59PM +0200, monstr@seznam.cz wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  0 files changed, 0 insertions(+), 0 deletions(-)
>>  create mode 100644 include/asm-microblaze/a.out.h
>>
>> diff --git a/include/asm-microblaze/a.out.h b/include/asm-microblaze/a.out.h
>> new file mode 100644
>> index 0000000..e69de29
> 
> As of 2.6.26-rc7 you do no longer need this header.
> 
> cu
> Adrian
I expect it but I haven't information about. I'll check it.

M




