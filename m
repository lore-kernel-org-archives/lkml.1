Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbZAEVzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbZAEVzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZAEVzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:55:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:29220 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbZAEVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=V1bXKXjpJTNLaWVc07uzsMrgr+mAkgzqU4Ug35G37Zza8T/ZoU97xaAGzbqxM74qCI
         QKIfb5hzCl01WXBglG93IOl3MSGHERi4VgvKtBfRYNFAtypxw5aXBOlWKC6WeVuBS15V
         fctB0aO3EIuJi2Swhnrjf1Uhm308xwuJCil4Q=
Message-ID: <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com>
Date: Mon, 5 Jan 2009 13:55:08 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: david@lang.hm, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: early exception error
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090102174845.GD5372@localhost> <20090102203058.GH5372@localhost>
	 <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>
	 <20090103161052.GB11093@localhost>
	 <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>
	 <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>
	 <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>
	 <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
X-Google-Sender-Auth: ab46246ec735d7e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you send out boot log with working kernel before 2.6.28?

need to look at the e820 table.

YH
