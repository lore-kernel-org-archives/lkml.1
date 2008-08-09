Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbYHIBqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbYHIBqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761610AbYHIBo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:44:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41532 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761507AbYHIBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P4ho5v+dmovSXOY0y0CRTamGv8PC32N06BumD47BDgo6Pb49YWEsCyMKyNGsUjhnXM
         P4xVIkbpaytHGMTaY5lJeu9iTkP8FL32VW8027ydorzPr/iVso6HAc6GpG1gxsyK3oTj
         oE+D7a4/PdoML+HY0w9B7aDOZWZZwQ8WA5l5o=
Message-ID: <a36005b50808081844r41d5761enb41d490bfa41f965@mail.gmail.com>
Date: Fri, 8 Aug 2008 18:44:24 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "=?UTF-8?Q?J=C3=B6rg_Ostertag?=" <Joerg.Ostertag@avira.com>
Subject: Re: [malware-list] Threat model for Unix Computers
Cc: "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
In-Reply-To: <200808081248.55590.Joerg.Ostertag@avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080805211445.GA28304@kroah.com>
	 <20080805204600.03ceca31@bree.surriel.com>
	 <20080806014435.GF8224@mit.edu>
	 <200808081248.55590.Joerg.Ostertag@avira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m791kodq029282

On Fri, Aug 8, 2008 at 3:48 AM, JÃ¶rg Ostertag <Joerg.Ostertag@avira.com> wrote:>        - giving access to the Desktop-PC to guest-users for>                 "just let me look up something in the internet">          and the guest-user on the Desktop not informing about the (in his point of>          view) urgent installation of there beloved>          Browser-malware^H^H^H^H^H -adware ^H^H^H^H^H -extention
Install the xguest package on Fedora (yum install xguest), use thefast user switch applet, and be done:
http://dwalsh.fedorapeople.org/xguest/
http://danwalsh.livejournal.com/14778.htmlÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
