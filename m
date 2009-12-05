Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbZLEABi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbZLEABi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbZLEABg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:01:36 -0500
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:56548 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932643AbZLEABW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:01:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tjZHUH0ZMCiyqpWF5pxBa1C/iD4RMR/UbV5tOht5inezm2+uNeBW1SOVi3Bytb1lnMJia4Tmkl4FQEiAU+D8+FSW4anuIXKn9jHsdgn12wnonUPnA6R2iRBOO4MuKvLY;
Date: Fri, 4 Dec 2009 16:00:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86/pci: claim SR-IOV bar in pcibios_allocate_resource
 -v2
Message-ID: <20091204160041.13c08608@jbarnes-piketon>
In-Reply-To: <4B0C90D8.2000407@kernel.org>
References: <4AFFB1E6.9040300@kernel.org>
	<20091124131912.2aabb852@jbarnes-piketon>
	<4B0C4E69.4090402@kernel.org>
	<20091124134008.0050a339@jbarnes-piketon>
	<4B0C90D8.2000407@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 18:05:12 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> so use correct allocation from BIOS, instead of later assign another
> one.
> 

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
