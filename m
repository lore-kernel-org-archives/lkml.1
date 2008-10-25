Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYJYHVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYJYHVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 03:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJYHVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 03:21:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:17410 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYJYHVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 03:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=M3okXhwITGirxHVejk57FHC6Z85F+xE3rW3phrdSHtuc2OzGL12JDhBnNHovIHmYPo
         IQ8pQtRdE9qvtl98R1pclnzkE5jocVqfgpIoJFb0+rZSymmBCoXmdsspirHws8dLhSEG
         nWhZpcR+QMpuMhbXCaKsCM5opZCVhTst4b+tQ=
Message-ID: <8db1092f0810250021p70be6b62wdbb9a4c1c20c7a27@mail.gmail.com>
Date: Sat, 25 Oct 2008 09:21:06 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, fabio.comolli@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend to ram I have this message:

ACPI Warning (nspredef-0852): \_WAK: Return type mismatch - found
Integer, expected Package [20080926]

s2ram seems works OK

dmesg, acpidump:
http://unixy.pl/maciek/download/kernel/2.6.28-rc1_wak/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
