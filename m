Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYCLJjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYCLJjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYCLJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:38:51 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:30909 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750970AbYCLJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:38:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4dsDY1Vt3bsA7KEEQEgUbBGKE6QN0ja+Mcx38AXS+5F8zcWKmnvg4IkTRBz0sACuldkYqTrDGrM1IxjvS/4LHfF8GhwD9WuqqcxUfAOGpJ5ZMBbeXIzssETW+08km0MqfqzvVIBhc0Sp3zzEIQg3YgJNST+bEcOiasylIJ6ohDE=  ;
X-YMail-OSG: kWsW5tEVM1mCzAllkk35pXjGYbOeBQWjoxb0CnQLvCGeCsl41A6djfgvJ986Y2BnrBwCLBvd3Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: ehci watchdog-related splatter in 2.6.25-rc4
Date: Wed, 12 Mar 2008 01:38:48 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       Rabeeh Khoury <rabeeh@marvell.com>
References: <20080312093045.GA24017@xi.wantstofly.org>
In-Reply-To: <20080312093045.GA24017@xi.wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120238.49050.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Lennert Buytenhek wrote:
> Seems like EHCI IRQ firing while ehci_iaa_watchdog() is running.

Does RC5 resolve this?
