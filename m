Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYKOMO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYKOMO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 07:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYKOMOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 07:14:17 -0500
Received: from nebensachen.de ([195.34.83.29]:50645 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbYKOMOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 07:14:17 -0500
X-Hashcash: 1:20:081115:loic.grenie@gmail.com::KqmE5CfHqQvWwLSS:00000000000000000000000000000000000000002zBR
X-Hashcash: 1:20:081115:gregkh@suse.de::ZRlq0qyzskRUmf4F:0008Cin
X-Hashcash: 1:20:081115:linux-kernel@vger.kernel.org::Lb/5v+2q2qlfESv7:0000000000000000000000000000000003hNy
X-Hashcash: 1:20:081115:stable@kernel.org::k9bUj236QnCnWSvB:000000000000000000000000000000000000000000000Gdm
From: Elias Oltmanns <eo@nebensachen.de>
To: =?iso-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Linux 2.6.27.6
References: <20081113185350.GA3765@kroah.com>
	<9b06e8d20811150238ye81f6dck7e81e275ba11da9d@mail.gmail.com>
Date: Sat, 15 Nov 2008 13:12:25 +0100
In-Reply-To: <9b06e8d20811150238ye81f6dck7e81e275ba11da9d@mail.gmail.com>
	(=?iso-8859-1?Q?=22Lo=EFc_Greni=E9=22's?= message of "Sat, 15 Nov 2008
 11:38:47 +0100")
Message-ID: <877i75p4ra.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Loïc Grenié" <loic.grenie@gmail.com> wrote:
>     No big deal, but commit 093327cb references
>   X86_CHECK_BIOS_CORRUPTION that is not available anywhere.

You are talking about commit 71556e92, I suppose. Since the change log
entry has been written for the original commit 5649b7c3 in Linus' tree,
it refers to a feature that is available there
(X86_CHECK_BIOS_CORRUPTION) but has only been merged into mainline after
the release of 2.6.27.

Regards,

Elias
