Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZINPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZINPrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZINPrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:47:45 -0400
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:40140 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755622AbZINPrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:47:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Bd/NcQalqP54vu0spy51XdugrV/aLbRazgRwNW8uyBC8DLo3rtfIarZx/BVdkc9EJuHlwAGqSgypqxC/t9EAa2kPfafE2YvGT+WACetFDOfMSnttiCiFdTNMIcIhBIWC;
Date: Mon, 14 Sep 2009 08:47:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] PCI Hotplug: internal interface cleanups
Message-ID: <20090914084735.09bd443d@jbarnes-g45>
In-Reply-To: <20090910183219.20011.41679.stgit@bob.kio>
References: <20090910183219.20011.41679.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 12:33:58 -0600
Alex Chiang <achiang@hp.com> wrote:

> This is a re-post of an old patch series that wasn't picked up last
> time due to being too late in the merge window.
> 
> It removes a bunch of copy/paste code in acpiphp by simplifying some
> internal interfaces.
> 
> Please consider this for .32.
> 
> Thanks!
> 
> v1 -> v2:
> 	- incorporated Kenji-san's comments
> 
> ---
> 
> Alex Chiang (2):
>       PCI Hotplug: acpiphp: find bridges the easy way
>       PCI Hotplug: convert acpi_pci_detect_ejectable() to take an
> acpi_handle

Applied to linux-next, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
