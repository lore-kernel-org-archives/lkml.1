Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZISOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZISOqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZISOqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:46:52 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36079 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZISOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:46:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: jorg@ml1.net
Cc: "Jorg Schummer" <ext-jorg.2.schummer@nokia.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to volume label
References: <1252420131.5782.2.camel@jorg-desktop>
	<1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	<878wgcsd1p.fsf@devron.myhome.or.jp>
	<1253276050.9376.1335476075@webmail.messagingengine.com>
Date: Sat, 19 Sep 2009 23:46:50 +0900
In-Reply-To: <1253276050.9376.1335476075@webmail.messagingengine.com>
	(jorg@ml1.net's message of "Fri, 18 Sep 2009 15:14:10 +0300")
Message-ID: <87ws3v2dr9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jorg@ml1.net writes:

> If 'preserve' (i.e. saving and loading the timestamp only IF a label is
> present) is the default, I'll remove the 'rootts=preserve' option.
> However, should there still be an option to switch this feature off
> completely ('rootts=ignore')?

I think it should be boolean (I.e. "rootts" as "rootts=preserve", and no
option as "rootts=ignore").

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
