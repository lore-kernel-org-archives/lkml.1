Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZCTWA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZCTWA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZCTWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:00:13 -0400
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:48322 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752244AbZCTWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:00:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZVeXE7ngcCkenBGEVO2Gptyp5wyM39atgsYi+gljKTSQ9KmSeTI3EwxuXYyuA7B0OBMojfDoMB7FrgRQf/G4NvmHuuNxdokNYI5DsaTbhWfS91A0DHWY6aFa2z9ncmOe;
Date: Fri, 20 Mar 2009 15:00:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v5 01/13] PCI: pci_is_root_bus helper
Message-ID: <20090320150005.565fb46d@hobbes.lan>
In-Reply-To: <20090320205555.12275.10712.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
	<20090320205555.12275.10712.stgit@bob.kio>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 14:55:55 -0600
Alex Chiang <achiang@hp.com> wrote:

> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> Introduce pci_is_root_bus helper function. This will help make code
> more consistent, as well as prevent incorrect assumptions (such as
> pci_bus->self == NULL on a root bus, which is not always true).
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---

Applied this series, thanks everyone!

-- 
Jesse Barnes, Intel Open Source Technology Center
