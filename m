Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYHUUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYHUUIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYHUUH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:07:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:3354 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbYHUUHz (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dGoHkZj+yPMUsPXEfYOTsEH7I8P4cZ7Y3TDDbnlejUnIfnCftsB46c0YaIWb6JZ0Vv
         A67gX5vnwq1M09iyRqYaJxQo8XHBLVFQdtR5FG3jAx2MXXKMH5S3mfsCbYCLc7wc51Vg
         KknkGceWfMWiQcA2tpDpC51dsrg4j6IpJzzjo=
Message-ID: <6934efce0808211307g4eabe29fvac24d82252bf913c@mail.gmail.com>
Date: Thu, 21 Aug 2008 13:07:54 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <1219324258.23311.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00E6.2070505@gmail.com>
	 <1219324258.23311.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it would be much cleaner to do all these similar macro's as
> static inline functions.

Yeah.  Been thinking about that.
