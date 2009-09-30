Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZI3LCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZI3LCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 07:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZI3LCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 07:02:04 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50285 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZI3LCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 07:02:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
References: <20090319181120.GA18034@frolo.macqel>
	<20090323085024.GA8897@frolo.macqel>
	<20090323140005.GB25840@frolo.macqel>
	<20090925194636.GA15700@frolo.macqel>
	<87vdj2ysk8.fsf@devron.myhome.or.jp>
	<20090929102559.GA4590@frolo.macqel>
	<20090929224340.GA9730@frolo.macqel>
Date: Wed, 30 Sep 2009 20:02:01 +0900
In-Reply-To: <20090929224340.GA9730@frolo.macqel> (Philippe De Muyter's
	message of "Wed, 30 Sep 2009 00:43:40 +0200")
Message-ID: <87ljjwzoeu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

>> > IIRC, Windows stripped the trailing ".". That filename can be read/used on
>> > Windows?
>> 
>> Sorry I don't use MS-Windows.  I'll try to find someone who does.
>
> MS-Windows (XP SP3) lists correctly the names with their trailing dots.

Ok. Is it meaning you could read the file correctly? I guess so, and
I'll review deeply about dcache issues for it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
