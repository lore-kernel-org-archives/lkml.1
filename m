Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYANV7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYANV7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYANV6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:58:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33099 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbYANV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w8ovGwxLRQ5it1Xdd8zjPhZ95YchM/ivPF8Y50OA0HTlqF7sF4kiwj2QIaXycom0AkLO3xFaW/v2RDXc2hM4cP6Z+TYYsA/vaHtr4fBmBW+gvvxE7TMBcZjB+GcKLJDunTs6Xs9qrHFLw3/WCBBXRvYWGMDJv+XFF5hE7cVkka0=
Message-ID: <6101e8c40801141358la75d1c6vb100247dbbd651a@mail.gmail.com>
Date: Mon, 14 Jan 2008 22:58:51 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20080114215209.GK9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com>
	 <20080114125200.28cb4c69@deepthought>
	 <20080114210105.GG9847@does.not.exist>
	 <6101e8c40801141331n3cb66c04pc74ff07faf04c8fd@mail.gmail.com>
	 <20080114213453.GJ9847@does.not.exist>
	 <6101e8c40801141341hcb17b08h2fd5244bccb21928@mail.gmail.com>
	 <20080114215209.GK9847@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I "tested" other devices resources file, and only with skge freezed
the system. from this think, that is skge driver bug

-- 
Thanks,
Oliver
