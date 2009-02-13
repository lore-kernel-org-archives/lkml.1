Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbZBMVc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbZBMVc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZBMVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:32:50 -0500
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:43743 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752881AbZBMVct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:32:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=EgQH9Tlu2Y0NNCRHcVn4EIFj4W7DjJK19rjuWbpYS9ffGFP3WSdYWaB/YpsoALUCoQLN43/49XdkG9u/yoFNBRD0TB9ecdqb7km6DjmKil+dLYP9EKWYnZBgXinnCc4m;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: Documentation: fix minor PCIe HOWTO thinko
Date: Fri, 13 Feb 2009 13:32:47 -0800
User-Agent: KMail/1.9.10
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090213190317.GB20356@ldl.fc.hp.com>
In-Reply-To: <20090213190317.GB20356@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131332.47473.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 13, 2009 11:03 am Alex Chiang wrote:
> Update doc to correctly refer to replacing the pci_register_driver API,
> and not the non-existent "pci_module_init" API.
>
> Signed-off-by: Alex Chiang <achiang@hp.com>

Applied to linux-next (though I should just pull it over to for-linus, will 
do), thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
