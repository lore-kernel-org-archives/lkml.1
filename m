Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbZLPTpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbZLPTpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZLPTpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:45:43 -0500
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:55271 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751248AbZLPTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:45:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=e3oW8qA/4PDM64sp54eSDwKylDZ3Fr+ZlbEdxsMnup5c1vxU/5YgOXrjSnziWRYeo6eTelA1/5Op8I17Iv6DvN3zMJXGbB9TI1nj+Fq9EkbAJgWDb38X7+aa3ivZhtmM;
Date: Wed, 16 Dec 2009 11:45:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stefan Assmann <sassmann@redhat.com>
Cc: linux-pci@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, ddutile@redhat.com, kaneshige.kenji@jp.fujitsu.com,
       Stefan Assmann <sassmann@redhat.com>, khc@pm.waw.pl
Subject: Re: [PATCH 1/2 v2] pci: change PCI nomenclature in drivers/pci/
 (comment changes)
Message-ID: <20091216114517.4efe1eb2@jbarnes-piketon>
In-Reply-To: <20091203114923.24905.48449.sendpatchset@localhost.localdomain>
References: <20091203114914.24905.67372.sendpatchset@localhost.localdomain>
	<20091203114923.24905.48449.sendpatchset@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 06:49:24 -0500
Stefan Assmann <sassmann@redhat.com> wrote:

> From: Stefan Assmann <sassmann@redhat.com>
> 
> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
> terms listed in the "Trademark and Logo Usage Guidelines".
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
> 
> Patch is limited to drivers/pci/ and changes concern comments only.
> 
> Signed-off-by: Stefan Assmann <sassmann@redhat.com>
> ---

Applied these, thanks.  The second one had a conflict since I had
previously applied a hotplug cleanup patch from you, but everything
else looked fine.

-- 
Jesse Barnes, Intel Open Source Technology Center
