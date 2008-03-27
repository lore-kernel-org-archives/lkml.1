Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYC0I0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYC0I0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYC0IZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:25:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:33641
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbYC0IZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:25:53 -0400
Message-ID: <47EB5A0F.50908@qumranet.com>
Date: Thu, 27 Mar 2008 10:25:51 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, kvm-devel@lists.sourceforge.net,
       linux-next@vger.kernel.org, hpa <hpa@zytor.com>,
       mingo <mingo@redhat.com>
Subject: Re: [kvm-devel] [PATCH v2] x86: don't allow KVM_CLOCK on Voyager
 or	Visual WS
References: <20080314104444.ca80e434.randy.dunlap@oracle.com> <20080325160846.d02b0209.randy.dunlap@oracle.com>
In-Reply-To: <20080325160846.d02b0209.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Prevent failed randconfig builds with KVM_CLOCK being enabled
> on Voyager or VISWS.
>
>   

Applies, thanks.

-- 
error compiling committee.c: too many arguments to function

