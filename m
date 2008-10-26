Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYJZOuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYJZOuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYJZOuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:50:06 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:41242 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbYJZOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:50:04 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: nfsroot.txt in 2.4.36.7 and 2.6.27.1, Configure.help in 2.4.36.7: missing precondition CONFIG_IP_PNP
To: Hartmut Niemann <Hartmut.Niemann@gmx.de>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 26 Oct 2008 15:49:58 +0100
References: <bqZbj-1sh-7@gated-at.bofh.it> <br4uu-ao-11@gated-at.bofh.it> <brcBJ-5JW-41@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Ku6wI-0001pL-LI@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartmut Niemann <Hartmut.Niemann@gmx.de> wrote:

> Maybe we should change the CONFIG_ROOT_NFS help section to
> "please read the CONFIG_NFS_FS help".

make config will not allow reading the CONFIG_NFS_FS help while asking for
CONFIG_ROOT_NFS.


