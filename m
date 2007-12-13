Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXLMVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXLMVZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765223AbXLMVZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:25:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40850 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbXLMVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:25:15 -0500
Date: Thu, 13 Dec 2007 22:25:13 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/42] Unionfs: filesystems documentation index 
In-Reply-To: <200712131506.lBDF633t032100@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0712132224490.15683@fbirervta.pbzchgretzou.qr>
References: <200712131506.lBDF633t032100@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 13 2007 10:06, Erez Zadok wrote:
>In message <Pine.LNX.4.64.0712101546460.25446@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
>> 
>> On Dec 9 2007 21:41, Erez Zadok wrote:
>> >
>> >Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
>> >---
>> > Documentation/filesystems/00-INDEX |    2 ++
>> > 1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> 
>> This is not CVS, you are allowed to have multiple files in a changeset
>> Perhaps fold 1-7.
>
>Agreed.  I've merged the documentation patches together, as well as several other
>related ones (esp. small ones); this also helps for bisecting.
>
Speaking of bisect, there is not really something to bisect in documentation
since it is not compiled :)
