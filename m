Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZJZVMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZJZVMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZJZVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:12:30 -0400
Received: from outbound-mail-315.bluehost.com ([67.222.54.8]:39491 "HELO
	outbound-mail-315.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752043AbZJZVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:12:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QtT8ykG5ClksvpcG8r72n7zGXrflW4UD3y0Lajjx4xSK/t5IJQqYH4+Tf52iW5vQ2K0J7X34mgs8C3jRpZGQCwhFST4a2BwLAGvobahv09yvMC4sgMb6C/P9DvHvASO1;
Date: Mon, 26 Oct 2009 14:12:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Allen Kay <allen.m.kay@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, matthew@wil.cx, chris@sous-sol.org,
       don.dugger@intel.com
Subject: Re: [ACS PATCH v5 2/2] adding xen dom0 checking
Message-ID: <20091026141230.377372f6@jbarnes-g45>
In-Reply-To: <4ACCD8DA.4030305@goop.org>
References: <1254936471-18602-1-git-send-email-allen.m.kay@intel.com>
	<4ACCD8DA.4030305@goop.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 11:07:22 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/07/09 10:27, Allen Kay wrote:
> > This patch is predicated on Jeremy's patch in include/xen/xen.h.
> >   
> 
> Feel free to include that patch in your series if you depend on it. 
> Otherwise it will get too awkward keeping track of everything.

Ok, I applied Allen's patchset along with your xen.h patch to my
linux-next tree.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
