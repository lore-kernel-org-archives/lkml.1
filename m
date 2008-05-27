Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYE0D3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYE0D3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 23:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYE0D3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 23:29:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:36800 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYE0D3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 23:29:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lElAECaDVNKUB8Mr4pd6XTs4E5F533Gil7KX51M71EwLWtr0lv4Sj59XQ1riiPOsc03hwBSeYGqsdjPp46VxW+/G7miDg+v0xHIdRYjXcwMkQd3VdNPyE1yPmc+TXTItRksp7sgpDXag8iaLBrVHz3vOITcc/UPQFLkQR1tkWjg=
Message-ID: <dd18b0c30805262029me288690y237f995fb63ccf54@mail.gmail.com>
Date: Tue, 27 May 2008 03:29:04 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: appletouch after wakeup
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; with 2.6.26-rc3 I've notice appletouch is going out of whack,
here's what I see after waking the machine from suspend,
[ 8186.661313] appletouch: incomplete data package (first byte: 2, length: 4).
Keep in mind there is not just one of these messages, the entire dmesg
is filled.

Also I decided to watch some DVD's and noticed this when using mplayer:
[14852.274794] end_request: I/O error, dev sr0, sector 11083800
[14852.276264] sr 0:0:0:0: [sr0] Device not ready: Sense Key : 0x2 [current]
[14852.276264] sr 0:0:0:0: [sr0] Device not ready: ASC=0x3a ASCQ=0x0
The same as appletouch, the entire dmesg is filled. Now during my
entertaining night  with will smith, jodie foster, and matt daemon I
did pause the movie to
take five. So maybe this might have cause the unalignment.
regards;

-- 
Justin P. Mattock
