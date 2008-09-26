Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIZFad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIZFad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYIZFaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:30:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:48816 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYIZFaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oJH9frPJsHZyidOObX4Q17cmDbVVOvkRTHDbBnNdahro/gme/ylfErCk93nZ20qmTp
         HXyA6+XOyKwHyAGyoi8bBur6G4XDwsxuHuRzoaG4NICz0ZkDsn/DnsQto2U9oEVtjnzI
         tWcYIBDdbVRDmxWqiTgrTHC3Vzi1bEzYLj1b8=
Message-ID: <df9815e70809252230x4eef3e1ep40a02f101cb90a87@mail.gmail.com>
Date: Fri, 26 Sep 2008 13:30:11 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: Multiple MSI, take 3
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
In-Reply-To: <20080711005719.GO14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080711005719.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 8:57 AM, Matthew Wilcox <matthew@wil.cx> wrote:
>
>
> Patchset available as a git tree from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi
> (multiple-msi-20080710 is this patch set in particular)
>
> Patches will be sent in reply to this message.
>

Hi Matthew, what's current state of this work? I pulled it into a
newly created git branch and tried to rebase it upon the latest Linus
tree, found that there are some merge conflicts.

-Jike
