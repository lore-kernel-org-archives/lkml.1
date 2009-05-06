Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZEFQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZEFQ0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEFQZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:25:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:37757 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZEFQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bhJJ39jVU00KWxnYeucvTYFrGMChJn9nIazynALzom/ONrWByDmDfWx06FpMv6SvCY
         msJ8W2S24MlnO9dOmSQQlkjXskw1Tr+9jwI1goe/Wj8lrQW69Ga/DbhBjPuVnc/1LjB2
         BpnbkMrSS7YsOr3ErhORNy5trhOb7XBwUAj10=
MIME-Version: 1.0
In-Reply-To: <a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
References: <a44ae5cd0905052049i2f4cfdeia64fb1c147c4da67@mail.gmail.com>
	 <a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
Date: Wed, 6 May 2009 12:25:54 -0400
Message-ID: <a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
Subject: Re: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting is 
	locking up my system when Xorg starts.
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I established an SSH connection to my laptop and then started Xorg
from the ssh session.  I saw the startup messages get to the point
where it specified which xorg.conf file was being used and then the
ssh session froze and eventually timed out.  So, this doesn't seem to
be an issue of just Xorg getting messed up.  Any guidance on what to
test now would be greatly appreciated.

          Miles
