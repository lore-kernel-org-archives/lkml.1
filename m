Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZBXKrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZBXKrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 05:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBXKrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 05:47:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43842 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBXKrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 05:47:41 -0500
Message-ID: <49A3D04A.9010501@redhat.com>
Date: Tue, 24 Feb 2009 12:47:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yu Zhao <yu.zhao@intel.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com>
In-Reply-To: <1235112888-9524-1-git-send-email-yu.zhao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu Zhao wrote:
> Greetings,
>
> Following patches are intended to support SR-IOV capability in the
> Linux kernel. With these patches, people can turn a PCI device with
> the capability into multiple ones from software perspective, which
> will benefit KVM and achieve other purposes such as QoS, security,
> and etc.
>   

Do those patches allow using a VF on the host (in other words, does the 
kernel emulate config space accesses)?



-- 
error compiling committee.c: too many arguments to function

