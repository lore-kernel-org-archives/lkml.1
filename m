Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYGaTjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYGaTjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYGaTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:39:36 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:39932 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752824AbYGaTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:39:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hoqzT2QshTE1AzB7DqafUQ1UcVvXhp6JZMWmwlTdEByePCNqiPlHrx0Gs2godCSlpOvh7/II8m3Om7QOxarnu7a9FPkKylDZRavd8UTHY99NK+AH/CKZGAHdMyh0g1hp;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] PCI: Limit VPD length for Broadcom 5708S
Date: Thu, 31 Jul 2008 12:39:28 -0700
User-Agent: KMail/1.9.9
Cc: benli@broadcom.com, willy@linux.intel.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
References: <48920413.6080508@cosmosbay.com>
In-Reply-To: <48920413.6080508@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311239.28769.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2008 11:27 am Eric Dumazet wrote:
> While trying to upgrade kernel from 2.6.25 to 2.6.26 on a ProLiant BL460c
> G1, I faced this problem on integrated Broadcom 5708S NIC when trying to UP
> them.

Thanks Eric, I applied this to my for-linus branch.  I'll bounce the original 
over to stable@.

Jesse
