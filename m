Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbYGQWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbYGQWF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYGQWFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:05:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:49251 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYGQWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to
         :subject:x-enigmail-version:content-type:content-transfer-encoding
         :sender;
        b=qYmyKyTZujegdZwCSHt5lr7SK3JqdX2O+UFxqo7Gd4WwSO5kdeQf4lCLqtCZVA1LsN
         AnMPqtxuTTbTIQVV/VN0Gl58fLAITie0W2ZdUmhXMvSm5KxZBiJ/RtQSEH5xmMa4PSxz
         oiGv4BNiObTDzUZhfZbGNR7JBo4WUYtBp5B/M=
Message-ID: <487FC213.9030604@altrux.me.uk>
Date: Thu, 17 Jul 2008 23:05:07 +0100
From: Alastair Stevens <alastair@altrux.me.uk>
Organization: Gloucester UK
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Forgive me if I missed it, but I've not seen any suggestions along the lines
of this: how about just dropping the now-meaningless '.6' from the version
string and retaining the rest. In other words:

   2.27
   2.27.1
   ...
   2.28
   2.28.1
   2.28.2

That way you continue the series in a meaningful way, whilst reverting to a
neater 3-level numbering scheme again. Perhaps you could make 2.[6.]30 the
switchover point....

Cheers
AL

- --
====================================================================
ALASTAIR STEVENS
* Web - www.altrux.me.uk
* Blog - www.altrux.me.uk/blog.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIf8ITxW64B3bJb+wRAlxMAJ0cRiRBeN2MVBxauLudZDBQ9mEjEACfVx0C
kNjXCycMZ+rxLvoMIVh0EAY=
=04yz
-----END PGP SIGNATURE-----
