Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbZKDVHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbZKDVHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbZKDVHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:07:46 -0500
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:60660 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932578AbZKDVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:07:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WWhvYI23UsgKGHUJlLqvldemPtvKWEANOS8JRQzlwRmYU0dTgoa/fd+l+zZ0qYUeH/OtUXXMvMeeclbS9nbdrE30fB2sAfpdZyJJ66xVBd8bTvrkGg8A/qR80d0cVdva;
Date: Wed, 4 Nov 2009 13:07:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Huong_Nguyen@dell.com
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091104130749.0686210d@jbarnes-piketon>
In-Reply-To: <20091104130515.6ffb0e2b@jbarnes-piketon>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com>
	<4ACEE220.1020705@jp.fujitsu.com>
	<20091009182810.GB24889@mock.linuxdev.us.dell.com>
	<20091009183319.GC24889@mock.linuxdev.us.dell.com>
	<4AEA4C82.6010604@jp.fujitsu.com>
	<20091030025313.GA1042@mock.linuxdev.us.dell.com>
	<4AEA5C52.2030900@jp.fujitsu.com>
	<20091102175123.GA4028@mock.linuxdev.us.dell.com>
	<20091104091106.32489ad7@jbarnes-piketon>
	<86802c440911041255i59024efckf496dfa966da8560@mail.gmail.com>
	<20091104130515.6ffb0e2b@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 13:05:15 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > can not find acpi_hest.c and acpi_hest.h
> > 
> > maybe need to wait acpi hest code is there?
> 
> Arg, when I fixed up a conflict in the patch I forgot to add those
> files to the commit.  They were in my tree so I didn't see a build
> error... Fixing now.

Should be all fixed now, thanks for catching it Yinghai.

-- 
Jesse Barnes, Intel Open Source Technology Center
