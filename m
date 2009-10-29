Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZJ2Qsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZJ2Qsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZJ2Qsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:48:38 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:51156 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755678AbZJ2Qsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:48:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VadQM9gqnUVHKcIsJYYtAHAD/bbWtXdvXfjIm/b8yBH7RJRSXUbGyxbXXgFSO8Yug7wxH7rcseWfQ/2EcfGonqE30bK5YW+9sQDnTRTLDstPnqsCNx7mQCTWEse8trnT;
Date: Thu, 29 Oct 2009 09:48:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Huong_Nguyen@dell.com
Subject: Re: [PATCH] PCIe AER: honor ACPI HEST FIRMWARE FIRST mode
Message-ID: <20091029094839.143186ac@jbarnes-g45>
In-Reply-To: <20091029141559.GB13809@auslistsprd01.us.dell.com>
References: <20091006173311.GA15751@auslistsprd01.us.dell.com>
	<4ACEE220.1020705@jp.fujitsu.com>
	<20091009182810.GB24889@mock.linuxdev.us.dell.com>
	<20091009183319.GC24889@mock.linuxdev.us.dell.com>
	<20091029141559.GB13809@auslistsprd01.us.dell.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 09:15:59 -0500
Matt Domsch <Matt_Domsch@dell.com> wrote:

> On Fri, Oct 09, 2009 at 01:33:20PM -0500, Matt Domsch wrote:
> > For review and comment.  Feedback from Hidetoshi Seto and Kenji
> > Kaneshige incorporated.
> 
> With no more comments received, I would like to see this applied.

Kenji-san and Hidetoshi-san, are you ok with me adding your Reviewed-by
tags to this patch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
