Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYFPMPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYFPMPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYFPMOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:14:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:54077 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYFPMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LynikEduHiABZ7ijmGEqbY/bhhbObA/nacDHM3/p3XGJFXQycB48A9p4E4Nb00/fNp
         pMg0Zw/teUR5Dbu7b76GQ3AUM7SNt8cs8w0bpwxssGP38hRCA3t1YPagXyWERcAae3EG
         hvL4glgyCiuvbyRp6AGm+C3tCTfzHwbEewdKM=
Message-ID: <bec9a5870806160514w79448b53ya622f4752253ae5b@mail.gmail.com>
Date: Mon, 16 Jun 2008 15:14:51 +0300
From: "Nameer Yarkon" <nameer.yarkon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Serial problem and request for guidance..
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Some of my serial rx data gets lost.

I can easily reproduce the problem on several kernel versions
and platforms (while I have several setups of different kernels
where this doesn't occur).
But I want to narrow it down a bit before filing a bug report.

In the meantime I would heartfully thank any guidance how I can
further debug this. Assuming I see the data on the lines
using a hardware sniffer, but then I do not receive it
on the host, any idea how I can debug this ?
Any hunch what it can be ? serial device misconfiguration ?

Thank you and sorry for such a vague report
and minimal info...
Nameer.
