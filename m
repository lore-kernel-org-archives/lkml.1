Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752381AbYLQTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbYLQTew (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYLQTeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:34:36 -0500
Received: from gw.goop.org ([64.81.55.164]:45547 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbYLQTef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:34:35 -0500
Message-ID: <49495447.5030904@goop.org>
Date: Wed, 17 Dec 2008 11:34:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
        Greg KH <greg@kroah.com>, "rdreier@cisco.com" <rdreier@cisco.com>,
        Jike Song <albcamus@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>	<20081217060608.GA12618@kroah.com>	<43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>	<200812171051.36645.jbarnes@virtuousgeek.org> <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F07554B525A02@orsmsx508.amr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rose, Gregory V wrote:
> -----Original Message-----
> From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
>
> On Wednesday, December 17, 2008 8:44 am Rose, Gregory V wrote:
>   
>> As noted in the attached email to the netdev list, we (e1000_devel) will
>> support the API.
>>     
>
> Do you think you'll have those changes ready for 2.6.29?  Would merging core
> SR-IOV support now make that any more likely?
>
>   
>
> I'm not sure about readiness for 2.6.29.  I can tell you that as soon as I get a Xen Dom0 kernel with these API's included it will take me less than a day to convert over to them from the current drivers I have that are using an older API from back in August.

Which dom0 kernel are you using?  Is it based on my pvops-based dom0 work?

    J
