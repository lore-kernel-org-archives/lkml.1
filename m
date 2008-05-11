Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbYEKRgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbYEKRgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYEKRg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:36:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:63812 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYEKRg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IQnrAkGKaLnN9CKUdK2hdCkJVsH5RtXfOQbPHoR7y1xG4y0S/fXFrGX1Dj03PB3sgGscyzIB36fW/FDkqDiotvB2Q5pkuXzDtZDrHHkWKxdKAuUAABJdvXNOJIppRhcqqs6Zx4G364S+tgPBtmL0n027lLkbNq/83mGv+sshI8E=
Message-ID: <a35fc1810805111036k31b928f4g961b783344aaf787@mail.gmail.com>
Date: Sun, 11 May 2008 14:36:27 -0300
From: "Marcelo Laia" <marcelolaia@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: HDIO_DRIVE_CMD failed on Dell Latitude D630
In-Reply-To: <48268ABC.9000700@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fa.JGa9Aoo1QI9XNBPx1yZ0T7IP4qY@ifi.uio.no>
	 <48268ABC.9000700@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/11 Robert Hancock <hancockr@shaw.ca>:

> What was the actual problem you were seeing?
>

My system didn't shutdown my sata hd correctly and when I turn up the
system (start it) there is a fsck check. The HD isn't umounted
correctly, I suppose. So, I think that this can damage my HD.

Before that problem, when I shutdown my notebook, I could see a
message like "The system was shutdown..." in red and than the system
is power off. Now, this message isn't showed and the system was power
down suddenly.

Thank you

-- 
Marcelo Luiz de Laia
Jaboticabal - SP - Brazil
sip:marcelolaia@ekiga.net

"Você vê as coisas como elas são e pergunta: por quê? Mas eu sonho com
coisas que nunca foram e pergunto: por que não? " - Bernard Shaw
