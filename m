Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYKGNRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYKGNRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYKGNRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:17:09 -0500
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:60300 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751287AbYKGNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:17:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fdOjasiNtWp00vMRGvfvyDSmgXaCey9d4Zc2r786eQHi/+u/wlX1A2xqqe/hd8WONEsrJXrkGSz/yQIbzTAhouApytrbz7PBVwtcGRq0zhTsZ3NxiJBVIt+NG+f2e6TR;
Message-ID: <49143E00.30003@uniscape.net>
Date: Fri, 07 Nov 2008 21:09:20 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: H L <swdevyid@yahoo.com>
CC: Greg KH <greg@kroah.com>, Yu Zhao <yu.zhao@intel.com>,
       randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       matthew@wil.cx, linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Xen-devel List <xen-devel@lists.xensource.com>
Subject: Re: git repository for SR-IOV development?
References: <20081106165914.GA13476@kroah.com> <104014.9320.qm@web45110.mail.sp1.yahoo.com> <20081107015844.GA11884@kroah.com>
In-Reply-To: <20081107015844.GA11884@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 124.76.3.39 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lance,

Thanks for your interest in SR-IOV. As Greg said we can't have a git 
tree for the change, but you are welcome to ask any question here and I 
also will keep you informed if there is any update on the SR-IOV patches.

Thanks,
Yu

Greg KH wrote:
> On Thu, Nov 06, 2008 at 11:58:25AM -0800, H L wrote:
>> --- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
>>
>>> On Thu, Nov 06, 2008 at 08:51:09AM -0800, H L wrote:
>>>> Has anyone initiated or given consideration to the
>>> creation of a git
>>>> repository (say, on kernel.org) for SR-IOV
>>> development?
>>>
>>> Why?  It's only a few patches, right?  Why would it
>>> need a whole new git
>>> tree?
>>
>> So as to minimize the time and effort patching a kernel, especially if
>> the tree (and/or hash level) against which the patches were created
>> fails to be specified on a mailing-list.  Plus, there appears to be
>> questions raised on how, precisely, the implementation should
>> ultimately be modeled and especially given that, who knows at this
>> point what number of patches will ultimately be submitted?  I know
>> I've built the "7-patch" one (painfully, by the way), and I'm aware
>> there's another 15-patch set out there which I've not yet examined.
> 
> It's a mere 7 or 15 patches, you don't need a whole git tree for
> something small like that.
> 
> Especially as there only seems to be one developer doing real work...
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

