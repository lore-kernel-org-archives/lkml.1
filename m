Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbZJOHdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbZJOHdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZJOHdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:33:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43846 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbZJOHdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:33:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD6D014.5010106@jp.fujitsu.com>
Date: Thu, 15 Oct 2009 16:32:36 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: ddutile@redhat.com, Krzysztof Halasa <khc@pm.waw.pl>,
       Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com> <adapr8p8zue.fsf@cisco.com>
In-Reply-To: <adapr8p8zue.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> FWIW, I think using the same nomenclature as the PCI-SIG documents is
> probably the least confusing option.  Inventing our own terminology that
> conflicts with the "upstream" PCI specs is just going to confuse things,
> even if the Linux terminology is "better." 

I think so too.

And lspci output is "GT/s".

Thanks,
Kenji Kaneshige


