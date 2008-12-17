Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751887AbYLQSvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbYLQSvw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYLQSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:51:40 -0500
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:43150 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751060AbYLQSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:51:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=iQuNt2ANY2Eu0QVIf/PwK6kk7KPrxWfi4F5xGiPIE+OI7Xu1fOk9hiTRiQ0XWy3XjZWOMRon3Ffenhve2Q2SQn+6PT2bF3gj2aHEybZIdX6u+PtDsaUywQKiu9eV7G11;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Wed, 17 Dec 2008 10:51:35 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Jike Song <albcamus@gmail.com>,
        "Zhao, Yu" <yu.zhao@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "achiang@hp.com" <achiang@hp.com>,
        "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081217060608.GA12618@kroah.com> <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F07554B525811@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171051.36645.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2008 8:44 am Rose, Gregory V wrote:
> As noted in the attached email to the netdev list, we (e1000_devel) will
> support the API.

Do you think you'll have those changes ready for 2.6.29?  Would merging core 
SR-IOV support now make that any more likely?

Thanks,
Jesse
