Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXE1KQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXE1KQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE1KQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:16:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:33484 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXE1KQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Zi7yhcfs4921XCuGTktB14Hy/EtZwPamGlva0VPOfWnG4br26LAVAEWgZlEHP6+p+K6ke2jmATMuSg5k3XXuJ57FGGJ5nSewrauCZBH9z7JKBtCEBWcctowE8sCQ/JA4eLmcpwBNXB7csLfx2JE/6QNX/ntwdIDz/n9OYsfk4ZU=
Message-ID: <84144f020705280316t3ac31cadwc3382c9804db88c1@mail.gmail.com>
Date: Mon, 28 May 2007 13:16:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "young dave" <hidave.darkstar@gmail.com>
Subject: Re: [patch -mm 1/1] remove useless tolower in isofs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <a8e1da0705280310q7f3124c0te58395fa3348dfa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
	 <84144f020705272300r28e7dd71y8328edf9df6ed171@mail.gmail.com>
	 <a8e1da0705280310q7f3124c0te58395fa3348dfa5@mail.gmail.com>
X-Google-Sender-Auth: e63404b333bcae9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, young dave <hidave.darkstar@gmail.com> wrote:
> Thanks,  can this small fix be merged?

Yes. Please be patient and wait for Andrew to pick it up.
