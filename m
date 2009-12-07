Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbZLGEaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbZLGEaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934475AbZLGEaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:30:19 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56825 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554AbZLGEaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:30:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RJjhFYquTcq3u4RCztLBT6jPTYktVBNpT1IzvUGAspoeMux9s0mMMcm5NDc4jOnIRk
         DfzqUzr/8S5Ms2K4fI1RyQGoWCfcWuqJtfTIVDTLm6WM7GqtpxbhFQ9qC8hIUOrT6Yyi
         vgSIJvODhejHM4hAfUqDtpP6Z/IbkDGbvarCc=
MIME-Version: 1.0
In-Reply-To: <4B1C6856.4060207@ct.jp.nec.com>
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
	 <20091204021444.GA8392@x200> <4B1888CE.8000406@ct.jp.nec.com>
	 <20091204051729.GA3927@x200> <4B1C6856.4060207@ct.jp.nec.com>
Date: Mon, 7 Dec 2009 07:30:22 +0300
Message-ID: <b6fcc0a0912062030q88117d4sdb49637d647230dc@mail.gmail.com>
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm 
	tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp,
       swhiteho@redhat.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/7/09, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> I understand it's a regression, so how about make this option Y by
> default?

Sorry, this is still loss in functionality for just one pointer in task_struct.
