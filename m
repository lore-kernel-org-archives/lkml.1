Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYCLNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYCLNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYCLNMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:12:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:13316 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYCLNMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:12:45 -0400
Message-ID: <e8eb01770803120612x701eb2e3o17a06497b78d2fd7@mail.gmail.com>
Date: Wed, 12 Mar 2008 14:12:44 +0100
From: "Zbynek Drlik" <drlik.zbynek@opentech.sk>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: kernel oops
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080312103312.GH27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e8eb01770803120245x7690e6a9te8ad04296aa3fc4d@mail.gmail.com>
	 <e8eb01770803120249te7453f6r61fc6c5d916446d6@mail.gmail.com>
	 <20080312103312.GH27894@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.
After i ran ldconfig oops has been added to dmesg and ldconfig crashed
with segmentation fault. (ldconfig activate oops). There is another
applications which crashes and oops apper in dmesg (paludis - gentoo
package manager)
Now I am back in kernel 2.6.22-r10 and all is ok.

On 3/12/08, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Mar 12, 2008 at 10:49:03AM +0100, Zbynek Drlik wrote:
>  > Hello. This is my problem after I upgraded to 2.6.24-r3. I am not to
>  > be able run ldconfig (segmentation fault).
>
>
> Could you bisect that?
>


-- 
S pozdravom Drlik Zbynek.

Ustecko-orlicka 16
058 01 Poprad
ICO: 41009347
Tel: +421 904 380 860
Web: www.opentech.sk
E-Mail: drlik.zbynek@opentech.sk
Skype: drlikzbynek ICQ: 365156504 Gtalk: drlik.zbynek@opentech.sk
