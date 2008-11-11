Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKKW2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKKW2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYKKW22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:28:28 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:58006 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753849AbYKKW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:28:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=nuZtY4rHZe59PEWNSWNBBuu6hrjZ0Ro5BI/jhughw6Jb2lCFxg6dhL8OJawIcqj3Se3gTSlCdUOYmiAm2j4dxBSc1J5mDsLDzOCmnClZRk7YTATg6hhFcGh/f1ixxtPQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] documentation: move MSI-HOWTO.txt to  Doc/PCI/
Date: Tue, 11 Nov 2008 14:28:20 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
References: <4910DA0B.1090309@xenotime.net>
In-Reply-To: <4910DA0B.1090309@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111428.20569.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 4, 2008 3:26 pm Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Move MSI-HOWTO.txt to the PCI/ subdirectory since it is PCI-related.
> Add PCI/ entry to top-level 00-INDEX file.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/00-INDEX          |    4
>  Documentation/MSI-HOWTO.txt     |  509
> ---------------------------------------- Documentation/PCI/00-INDEX      | 
>   2
>  Documentation/PCI/MSI-HOWTO.txt |  509
> ++++++++++++++++++++++++++++++++++++++++ 4 files changed, 513
> insertions(+), 511 deletions(-)

This is just a move, so totally up to the doc guys, but fwiw:

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Since there were some other moves going on here, I suggested on IRC that Randy 
set up a git tree and just have Linus pull it directly.

Jesse
