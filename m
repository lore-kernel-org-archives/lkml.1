Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbZKFT4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbZKFT4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbZKFT4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:56:32 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59934 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbZKFT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y6faEQlsfzQWE0OYEsZeoyjyFIo6n//FjkERHk/QHmNhiqYz7xgRszbatP5aRMv6vd
         KkOY6O+5dvCfPTRmj1FiOiia0lgDEcZBa0V/PHGOIuaFtlpFNYDeWdruzPFdbrOgRC7k
         MdNDx41j/GcMlZBxxU819TA8IlE6AzokvShMQ=
Message-ID: <4AF47F6C.1010100@gmail.com>
Date: Fri, 06 Nov 2009 20:56:28 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-wireless@vger.kernel.org,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 00/41] rewritten rt2800 drivers
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <43e72e890911051306q632ad8ar833346f5a4ea60fa@mail.gmail.com> <4AF340CE.5000709@gmail.com> <200911061728.42531.bzolnier@gmail.com>
In-Reply-To: <200911061728.42531.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/09 17:28, Bartlomiej Zolnierkiewicz wrote:
> 
> I have also small process related suggestion: if possible please group ACKs
> together into the reply for 00/ mail (like you just did now), this way there
> is a higher chance that I will not lose some of ACKs or review comments.
> 

Yep. No worries. Will do that for future patch series (which I hope will not be
as large as 41 patches anymore ;-))

---
Gertjan.

