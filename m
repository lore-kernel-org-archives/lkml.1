Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZI0XsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZI0XsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 19:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZI0XsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 19:48:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:54526 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZI0XsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 19:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Fwb+Yd1XAO3/xjugrHAK3QQ2fIrzq6HY59lLXJwKySd9eaF3i8iZyr2gDspRfPEMIs
         yBcZKE5CE6WIFvqWik3pUpXLhnyVmvz/B+peNRqvHnKMzycXa210JAD6BzvWK2UrMvbq
         1mH/roDmcbISkWe57mBc48lZJUcsXQjZbreGw=
From: Diego Calleja <diegocg@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Linux 2.6.32-rc1
Date: Mon, 28 Sep 2009 01:48:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-08936-g851b147; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <20090928094458.4ad704c2.sfr@canb.auug.org.au>
In-Reply-To: <20090928094458.4ad704c2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909280148.09060.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lunes 28 Septiembre 2009 01:44:58 Stephen Rothwell escribió:

> Of course, you realise that you set EXTRAVERSION to -rc2  :-(

Not a big problem i guess, except that the kernel.org files are "-rc1"
