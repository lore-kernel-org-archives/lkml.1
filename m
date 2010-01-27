Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624Ab0A0MPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0A0MPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521Ab0A0MPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:15:37 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:38991 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0A0MPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c7lkG3ra5PF3flomw0nuU2X+n6TYhKdynhqt7neLko2PSliCUudcSEnIP64nEydkyW
         ky8ZP6onR8zEE56NuwJ15HpIip7j+UC+frHi7OeGmkQO2ktEH+NnH6NDUc2DgV6erscn
         AVX87IS3qR2sJagy7ux2VOn4pPftSlNCO7gos=
MIME-Version: 1.0
In-Reply-To: <aacba7e1001262136o3b1cfb97yed421bba02580bef@mail.gmail.com>
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>
	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>
	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
	 <4B5F62C2.4000800@pobox.com>
	 <aacba7e1001261624m4358e4ebwcf8e2305b0c5fc16@mail.gmail.com>
	 <4B5FA38A.5040700@teksavvy.com>
	 <aacba7e1001262136o3b1cfb97yed421bba02580bef@mail.gmail.com>
Date: Wed, 27 Jan 2010 17:45:35 +0530
Message-ID: <aacba7e1001270415o7795db4bva32a5a23068e5d08@mail.gmail.com>
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
From: Vishal Rao <vishalrao@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27 Vishal Rao <vishalrao@gmail.com>:
> And here is the output of hdparm --Istdout /dev/sd? :
> http://pastebin.ubuntu.com/363660/

Apologies, pasting the output inline:

/dev/sda:
0c5a 3fff c837 0010 0000 0000 003f 0000
0000 0000 5335 3935 3031 352d 4146 4258
2d42 3131 3931 3936 0000 ffff 3000 3139
3136 2020 2020 4352 5543 4941 4c5f 4354
3132 384d 3232 3520 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8001
0000 2f00 4000 0200 0200 0007 3fff 0010
003f fc10 00fb 0101 c2b0 0ee7 0000 0007
0003 0078 0078 0078 0078 4000 0000 0000
0000 0000 0000 001f 0506 0000 004c 0040
01e0 0000 346b 7d01 4022 3469 3c01 4022
407f 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 c2b0 0ee7 0000 0000
0000 0000 4000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0009 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0001 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0001 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 27a5
