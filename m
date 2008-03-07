Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYCGQLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYCGQLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYCGQLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:11:08 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:42196
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYCGQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:11:06 -0500
Message-ID: <47D16878.9010808@qumranet.com>
Date: Fri, 07 Mar 2008 18:08:24 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: headersinstall of kvm.h does not work
References: <200803071326.06682.borntraeger@de.ibm.com> <47D13BD1.30801@qumranet.com> <200803071457.18735.borntraeger@de.ibm.com>
In-Reply-To: <200803071457.18735.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Freitag, 7. März 2008 schrieb Avi Kivity:
>   
>> As I'm about to disappear for a week, consider a patch to remove the 
>> config dependency and add asm-*/kvm.h pre-acked for mainline.  Maybe the 
>> presence of those empty asm-*/kvm.h files will encourage further kvm 
>> ports to *.
>>     
>
> Something like the following for all architectures?
>
>   

Yes.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

