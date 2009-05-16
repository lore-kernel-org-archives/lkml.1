Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZEPTNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZEPTNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZEPTMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:12:54 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:51198 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZEPTMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J5OpZJIFGDVTpNPpfwIIbTsLe6ZhGJe2yM6yZHmta+K+cJXhPd4ScmbP74E5/wWaag
         aZE7QdHY2frRV0OdZqnpO/PdPusxaB2nBRMuZqRN/L3HljWk5nReGTp6RNvgMzQPBRcU
         gUH9O/Wn+K2CTi7omzprcUdBDsIcynCLo3tdI=
MIME-Version: 1.0
In-Reply-To: <87zldc9987.fsf@sycorax.lbl.gov>
References: <87zldc9987.fsf@sycorax.lbl.gov>
Date: Sat, 16 May 2009 23:12:52 +0400
Message-ID: <a4423d670905161212u53869568ha9b6fa6a2b1c97e4@mail.gmail.com>
Subject: Re: oops with 2.6.30-rc6 and reiserfs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Alex Romosan <romosan@sycorax.lbl.gov>:
> i get an oops trying to boot into 2.6.30-rc6 with reiserfs as the root
> partition. the root partition never gets mounted rw so there is
> nothing in the logs but i took a picture of the screen on the laptop:
>
>  http://costard.lbl.gov/~romosan/dsc05513.jpg
>
> these are the config options i use relevant to reiserfs:
>
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_REISERFS_FS_XATTR is not set
>
> hope this helps.
>

Add CC.
