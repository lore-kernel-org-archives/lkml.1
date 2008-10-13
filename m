Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYJMLNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYJMLNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYJMLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:13:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:2495 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYJMLNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZBdQ2JbvgTG2Ezmi2IwpyujxFtHnLNjz2i9Hl67GqJ3nqiat27frUkPogSffHnjqUM
         HjQjMhHO5h1rgyfh9Arp/57SiAS7a1UgDgTYTpnchz55oDTVagxzGUYFJMa9AQsKOAVV
         a+qepy2Ew55l0BHcklb5jZw50PbHLsd8B0Fy8=
Message-ID: <912ec82a0810130413w4964d88br95f286d800a0545d@mail.gmail.com>
Date: Mon, 13 Oct 2008 13:13:01 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: section mismatch with a platform driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081013095018.GC29938@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
	 <20081013095018.GC29938@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 11:50 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> any idea what's the problem ?
>
> The function has a wrong name.

Thanks but that was just in-mail editing problem..
