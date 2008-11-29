Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYK2Div@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYK2Div (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 22:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYK2Dil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 22:38:41 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:39123 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbYK2Dik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 22:38:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=h9d_Gi0u-OkA:10 a=JM--fFyA78oA:10
 a=aEgOpVDluWW_8tBuiSoA:9 a=yu-WAxOG74ARTSo6AMnRxcCMWvMA:4 a=c5zHXd76wwQA:10
Date: Fri, 28 Nov 2008 22:35:17 -0500 (EST)
From: "Brian S. Julin" <bri@abrij.org>
To: Len Brown <lenb@kernel.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and
 rfkill control
In-Reply-To: <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org>
References: <20081127190517.GA25429@srcf.ucam.org>
 <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Nov 2008, Len Brown wrote:
> needs a MAINTAINERS entry.

If it were to be set to me it would have to be S: Odd Fixes.  I don't know if this
is on Matthew's redhat-official "pile of laptops"...

Either way I've marked the webpage hosting the original code as depricated 
and added a link to linux-acpi's home.  I'll have to test the new patch too 
at some point but not this weekend.

--
Brian
