Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYKCVhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYKCVhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYKCVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:37:10 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:50621 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYKCVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:37:09 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: how much license information inside the kernel ?
To: Pavel Machek <pavel@suse.cz>, devzero@web.de, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 03 Nov 2008 22:37:00 +0100
References: <bsDqj-4Tl-49@gated-at.bofh.it> <btOjA-7Sx-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kx76a-0002Qn-FL@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> wrote:
> On Thu 2008-10-30 11:54:57, devzero@web.de wrote:

>> i found that there is a LOT of repeating licensing information in the kernel.
>> 
>> for me,
>> 
>> find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU General
>> Public License|Free Software Foundation|version 2 of the License|distributed
>> in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A PARTICULAR"
>> 
>> gives a file sized ~3.5M
> 
> Now gzip it :-).

Now multiply it by the number of users.

