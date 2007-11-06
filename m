Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbXKFBmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbXKFBmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbXKFBmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:42:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:48437 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbXKFBml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=V0Eka855A+NyThWURsIoUNsWTboH1McItOtqySz9xRuXfadY/NJsYPAOaCHDNpF6OIfqb5exSymlYYv0H4IqOhqECy9nfR9A/VhQ/G5F2rJ1iWFDEhTKlpCuLneFChBRCgSVRC7ujE9HgKcDLsKw+4q/ghyNwSaHA7kKscwTj+E=
Message-ID: <2ed59cbb0711051742k5e4a7858ie95126399006ba53@mail.gmail.com>
Date: Mon, 5 Nov 2007 20:42:39 -0500
From: "Zurk Tech" <zurktech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Truecrypt in kernel ?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i was trying to move my truecrypt container from my xp box to my
debian etch box.
on windows xp its just double click to mount it, no need to even
install with the portable option.
on linux i had to download the source of the kernel, compile it, add
the truecrypt module, reboot and then mount it.
just wondering why the truecrypt module isnt in the mainline kernel ?
its the only cross platform encrypted disk solution out there and it
should be less of a chore to use it in linux...is there something
wrong with the truecrypt kernel driver ?
